# Clickupy - API + FUSE for Clickup


**TL:DR** `pip install clickupy` / https://github.com/dang3r/clickupy

Over the past few years, I have used many different project management tools.
JIRA has been a consistent one, and the tool with the most name recognition.
Trello is a very lightweight alternative, and the the one I personally use.
Redbooth is another big player and I've used it heavily (especially while working
there!). Wrike and Asana are a few others I've encountered every now and then.

It was surprising to learn about Clickup, which I have started to use at work.
Largely similar to the other solutions provided, I find it strikes a nice balance
between being lightweight and powerful. It has a sleek UI, a well-documented
API and is easy to use. The only complaint I've heard is that the ids
for tasks are actually UUIDs and not integers but I don't consider that an issue.

When using these tools for software engineering, it becomes useful to attach task ids
to pull requests. Most tools have integrations with the big players (Github, Gitlab)
that can detect when code for a task is merged, and will close the task for you.
To do this, you can attach the task id to the branch name, the pull request title
or the body of the commit.

```bash
$ git checkout -b dang3r/CL-asdji/clickup-blogpost
$ # do work ....
$ git commit -m "CL-ASDJI Make a new Clickup blogpost"
$ git push
```

One small complaint I've had is for every new branch I create, I have to:

- leave my terminal
- log onto the project management tool website
- search for my task
- find and copy the id
- come back to my terminal

It would be nice if there was a tool that automatically did this for you,
or allowed you to retrieve task ids via a CLI.

Whenever thinking about optimizing a workflow, you should always consult the
lovely xkcd [Task Automation](https://xkcd.com/1205/). In this case, I do the task
often enough, so I thought why not?

My initial thoughts for a project were:

- Make a simple API client 
- Create a CLI wrapping the client
- Build a thin tool that helps developers create branches from task ids

The project was going to be written in python, and was aptly named...

# Clickupy

Clickup has a well documented [API](https://clickup.com/api). It is currently in
beta, but provides access to most resources. They provide an
[API blueprint](https://jsapi.apiary.io/apis/clickup.source) which was nice.
It is much less comprehensive than an OpenAPI v3.0 spec, but its nice they provide it.

Making the HTTP-API client was straightforward. You can retrieve your API token by
navigating to your Apps on Clickup (settings -> apps). 

Once that was done, a CLI was required. For python projects, I love to use 
[Click](https://click.palletsprojects.com/en/7.x/). The CLI wrapped the API,
and allows you to retrieve information about a user's project, spaces, teams, etc.
When deciding what to print for the CLI, I thought about simply printing the JSON
response bodies of the API. However, they are not the most user friendly and for
the initial task at hand, you only need a subset of the information.

To handle this, I allow users of the CLI to pass in a format parameter that allows you print
json or human-friendly messages.

```shell
$ clickup --help
Usage: clickup [OPTIONS] COMMAND [ARGS]...

  A command line tool for interacting with clickup

Options:
  --format [human|json]
  --api_key TEXT         An API KEY for clickup  [required]
  --help                 Show this message and exit.

Commands:
  fuse      Create a FUSE filesystem for clickup resources
  projects  Get a space's projects
  spaces    Get a team's spaces
  tasks     Get a team's spaces
  team      Get a user's team
  teams     Get a user's teams
  user      Get a user
```

At this stage, you could easily use it to solve my initial problem : getting the task id
so you can create your branches

```shell
$ clickup --format human teams
13333337 acme.corp 17 users
dcardoza@neutrino.local:clickupy $ clickup --format human tasks 13333337
abcdef Design battle plans for fighting the night king
zyzyza Perform cool ritual to get help from the lord of light 
humanb Sacrifice the bulk of your cavalary in a pointless charge (but it will look cool)
...
$ git checkout -b CL-abcdef/design-battle-plans
```

And bam, we are now done. Right?

No. It was at this time my roomate [Adrian](https://www.linkedin.com/in/adrian-ziegler-millard-3822ba163/)
started discussing FUSE filesystems with me. They sounded like a cool idea. I thought
it would be cool if you could take an API and provide a filesystem interface to it.
The clearest parallel is that the PATH for a rest resource translates
nicely to file directory paths. I decided to look at this further.


### FUSE

FUSE allows you to make a filesystem in userspace. This makes much more developer friendly
than trying to learning what goes into a kernel filesystem.

For the purpose of `clickupy` I wanted to create a simple directory, that displayed information about
a user's metadata, and their teams. This was a much more scaled down version of my initial
plans.

To begin implementing, I found [python-fuse-sample](https://github.com/skorokithakis/python-fuse-sample)
that provides a easy interface to build your API around. Simply put, you are given a class
that has to implement a set of methods that are called when files are accessed on your FUSE
filesystem. Some of these are:

- `access` : Does the user have access to the file?
- `read` : Return bytes containing the content for a file.
- `readdir` : Return a list of files in a directory

When building this part of the project, a few things became apparent:

#### HTTP Paths <-> FS

HTTP paths are the same as paths on a filesystem. The method signatures for FUSE
typically give you the path of the file in question. Handling requests for a file
were similar to how requests are handled for the HTTP API. 

Most web frameworks provide a way to map a route with a handler. I decided to use
the same for this project.

```python

# HTTP Router for Tornado
def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
        (r"/foo", FooHandler)
    ])

# File Router for Clickupy
class Router:
    """
    A router that matches filesystem operations at a given path
    to a handler
    """
    def __init__(self, client):
        self.client = client
        self.handlers = [
            (r"^/$", BaseHandler(client)),
            (r"^/user$", UserHandler(client)),
            (r"^/teams\/?$", TeamsHandler(client)),
            (r"^/teams/[0-9]+$", TeamHandler(client))

        ]
```

#### Usefulness of different interfaces

This project eventually provided an python API, a CLI and a fuse filesystem
to access the same data. Each could be consumed by a different type of user, with
varying levels of control.

### Finished Product

Now, users can do the following and look at a subset of their Clickup resources
on the filesystem

```
dcardoza@neutrino.local:clickupy $ clickup fuse cl-fs > /dev/null 2>&1 &
[1] 27590
dcardoza@neutrino.local:clickupy $ tree cl-fs/
cl-fs/
├── teams
│   └── 13337
│   └── 13123
│   └── 1113
│   └── 99991
└── user

1 directory, 2 files
dcardoza@neutrino.local:clickupy $ cat cl-fs/user 
{
  "user": {
    "id": 1,
    "username": "Daniel Cardoza",
    "color": "#ff8asd",
    "profilePicture": "https://cool-glasses.jpg",
    "initials": "DC",
    "week_start_day": null,
    "global_font_support": false
  }
}dcardoza@neutrino.local:clickupy $ cat cl-fs/teams/13337
{
  "team": {
    "id": "13337",
    "name": "Foo co",
    "color": "#ffffff",
    "avatar": "www.image.ca",
    "members": [
        ...
    ]
```

# Closing thoughts

This was a fun project to make, and allowed me to learn more about Clickup and FUSE.
Although I will probably stop working on this project, there are a few extensions of it
worth thinking about

### Providing filesystem interfaces for HTTP APIS

Tools like API blueprint, swagger, OpenAPI, protobufs provide declarative ways of
interacting with APIS. It would be cool if a project existed that could take any of
them and create a FUSE filesystem for it.

### Make clickup's FUSE filesystem map to HTTP paths

This is similar to the previous point, and can simplify the implementation.

### Tool that integrates `clickupy` with git

Currently this is a manual process. A user can retrieve the task id of a task
by using `clickup tasks` and `grep` off the title, to make a nmew git branch.
A simple wrapper could automate this. This idea could be extended to other
project management providers too.

# Blog

This is my first blogpost in quite a while. I hope to continue writing posts
about various projects, and become a writer as a result.

Thanks for reading! If you'd like to contact me, my contact info is on this website :)

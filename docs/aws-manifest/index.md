# aws-manifest


**TL:DR** `pip install aws-manifest` / https://github.com/dang3r/aws-manifest

I recently needed to retrieve a list of all Amazon Web Services (AWS) services, and
actions that could be called on them. I wanted to answer questions such as "What
are all of the api actions that can be done for ec2?".

There is no API for doing so from AWS, so I started looking for other options.
Some projects scrape the AWS documentation and extract the data from the markup.
This is how projects like https://iam.cloudonaut.io/ work. You can see the code they use
for scraping and parsing in their github repo [here](https://github.com/widdix/complete-aws-iam-reference/tree/master/tools).

I haven't been able to find the thread on the aws forums, but I recall someone mentioning
you could scrape or get the data from https://awspolicygen.s3.amazonaws.com/policygen.html.
Awspolicygen is a tool for generating aws policies for their services.

This started my shallow dive into doing this.

### Extracting a manifest of aws apis and services

The site looks exactly like you'd expect.

![AWS-S3-PolicyGen](/images/s3_policygen.png)

Looking at the assets it loads, I saw an interesting `policies.js` bundle.

![AWS-S3-PolicyGen-Assets](/images/s3_policygen_assets.png)

Inspecting its content, it is just assigning an object to a global variable.
![AWS-S3-PoliyGen-Js-Bundle](/images/s3_policygen_asset_js.png)

If you remove the assignment to the variable, and put it into Jsonlint, you get
a valid json file.

![Jsonlint](/images/s3_polygen_jsonlint.png)

After analyzing the object, it had all of the necessary information to answer
the question. I wanted to use ask these questions from Python, so I made
`aws-manifest`

### aws-manifest

The package provides an easy interface for getting access to the full manifest,
and answering simple questions. It is able to either remotely pull down
the latest version of the manifest, or use one bundled with the package.

```python3
>> from awsmanifest import manifest, AwsManifest

# Retrieve the latest set of aws resources
>> m = manifest()
>> print(m["serviceMap"]["Amazon EC2"]["Actions"])

# Retrieve the bundled local copy of aws resources
>> m = manifest(local=True)

# For helper functions, use the `AwsManifest` class
a = AwsManifest()
print(a.service_prefixes())
print(a.actions("Amazon EC2"))
print(a.actions("s3"))
```

After publishing to pypi and github, I decided to search for references
to the javascript file. Lo and behold, https://github.com/search?p=1&q=https%3A%2F%2Fawspolicygen.s3.amazonaws.com%2Fjs%2Fpolicies.js&type=Code.

Its cool to see how common this workaround is.



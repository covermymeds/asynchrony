# asynchrony
GETs data from a url, retrying if an error code is found
=============

Like most poller gems, polls a given URL to see if data is ready.  The difference? If data is ready, it returns that data.
Assumes that the website in question will return an error code if there is no data.

For example:
Assume there is a URL, www.my_awesome_example.com/random_data, that either returns a 404 error or some actual JSON.

`Asynchrony.get("www.my_awesome_example.com/random_data")` will re-poll if a 404 error is seen, and return the JSON data it finds


The number of retries is finite, and if the GET is not successful it will raise an Asynchrony::HTTPError.

## Use
When all goes well:
```
important_json = Asynchrony.get("www.my_awesome_example.com/random_data")
render important_json
```

When no data is gotten:
```
important_json = Asynchrony.get("www.my_awesome_example.com/random_data")
#==> Asynchrony::HTTPError: 404 error receiving data from 'www.my_awesome_example.com/random_data'
<code: 404. successful: false. body: I suck.>   # the actual result that was received
```

If you intend to get data more than once (yes, this is a contrived example):
```
def same_response?
  endpoint = Asynchrony.watch("www.my_awesome_example.com/random_data")
  send_thing_to_awesome_example
  response1 = endpoint.result   # or endpoint.get

  send_thing_to_awesome_example
  response2 = endpoint.result

  response1 == response2
```

## Configuration
Asynchrony supports basic configuration.  The number of retries and the amount of time to wait between retries can both be modified.

By default:
 - there are 10 retries
 - it will wait at least 1 second between retries, increased exponentially
 - it will wait no more than 10 seconds between retries
 
These can be changed if you actually get an object, e.g., use the Asynchrony.watch method call:
```
endpoint = Asynchrony.watch("www.my_awesome_example.com/random_data")
endpoint.retires = 5
endpoint.min_wait_time = 0.5   # wait at least half a second between retries
endpoint.max_wait_time = 60    # wait as long as a minute between retries
```
 

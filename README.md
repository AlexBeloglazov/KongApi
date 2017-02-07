KongApi v. 0.1
-

### Usage

#### KongApi

KongApi is a main class of the module. An instance of this class can be used to create Kong objects (Consumer, API, Plugin), as well as retrieve object(s) from Kong server.

Examples:

1. Get an instance of KongApi for Kong Admin server at 127.0.0.1:8001:
	```perl
	use KongApi;
	my $kong = KongApi->new(server => 'http://127.0.0.1:8001');
	```

2. Get an instance of KongApi with certain HTTP timeout (in seconds) for all requests to the Admin server:
	```perl
    my $kong = KongApi->new(server => 'http://127.0.0.1:8001', ua_timeout => 5);
    ```

3. Searching for Consumers:
	```perl
    my $found_consumer = $kong->consumer->findOne(username => 'John');
    
    # or you can get a list of consumers
    
    my $consumers = $kong->consumer->find(size => 10);
    
    # now $consumers is an anonymous array of size <= 10 of KongApi::Objects::Consumer objects
    ```

4. Searching for APIs:

	```perl
	my $found_api = $kong->api->findOne(name => 'Mockbin');
    # or
    my $found_api = $kong->api->findOne(id => '4d924084-1adb-40a5-c042-63b19db421d1');

    # or you can get a list of APIs
    
    my $apis = $kong->api->find(size => 10);
    
    # now $apis is an anonymous array of size <= 10 of KongApi::Objects::Api objects
    ```
    Note: You also can pass to the *find()* method any of Request Querystring Parameters mentioned in Kong Admin API Documentation.

6. Searching for Plugins:
	```perl
    my $found_plugin = $kong->plugin->findOne(id => '4d924084-1adb-40a5-c042-63b19db421d1');
    
    # or you can get a list of plugins
    
    my $plugins = $kong->plugin->find(size => 10);
    
    # now $plugins is an anonymous array of size <= 10 of KongApi::Objects::Plugin objects
    ```
    Note: You also can pass to the *find()* method any of Request Querystring Parameters mentioned in Kong Admin API Documentation.

Methods *find()* and *findOne()* support passing optional arguments:

   - on_success - reference to a subroutine that will be executed operation finished successfully. Found object or anonymous list of objects is passed to the subroutine as an argument.
   
   ```perl
   $new_consumer->findOne(username => 'John', on_success => sub {
   my $found_consumer = shift;
      say "Found consumer's id: " . $found_consumer->id;
   });
   ```
   - on_error - reference to a subroutine that will be executed if an error occured. KongApi::Response object is passed to the subroutine as an argument.
   
   ```perl
   $kong->consumer->find(on_error => sub {
      my $server_response = shift;
            say "Error code: " . $server_response->code;
            say "Server said " . $server_response->message;
   });
   ```

#### Consumer

KongApi::Objects::Consumer is an abstract representation of Kong Consumer object. Instance of KongApi::Objects::Consumer has the same set of attributes, specifically:
* id
* custom_id
* name
* created_at

Supported for mutation attributes can be changed and saved back to the server. 

Examples of usage:

1. Create a new Consumer object without saving it to the server:

	```perl
   my $new_consumer = $kong->consumer->new();
   # also you can set corresponding attributes through constructor
   my $new_consumer = $kong->consumer->new(username => 'John');
   ```
2. Add Consumer to the server:
	```perl
    my $saved_consumer = $new_consumer->add;
    # or you can do everything in one line
    my $saved_consumer = $kong->consumer->new(username => 'John')->add;
    ```
    Method *add()* returns KongApi::Objects::Consumer object if the consumer has been added successfully, otherwise it returns *undef*.
   
3. Update a name of consumer:
	```perl
    my $consumer = $kong->consumer->findOne(username => 'John');
    if ($consumer) {
    $consumer->username('Joe')->update;
    }
    ```

4. Delete consumer from the Kong server
	```perl
    my $consumer = $kong->consumer->findOne(username => 'John');
    if ($consumer) {
    $consumer->delete;
    }
    ```

Optional arguments for *add()*, *delete()*, *update()*, *add_update()* methods:
- on_success => sub {}
- on_error => sub {}

#### API



### Installation

To install this module type the following:

```bash
perl Makefile.PL
make
make test
make install
```


### Dependencies

This module requires these other modules and libraries:

  **Moo >= 2.003**

### Copyright and License

Copyright (C) 2017 by Alexander Beloglazov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.24.0 or,
at your option, any later version of Perl 5 you may have available.

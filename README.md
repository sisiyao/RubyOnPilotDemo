# Ruby on Pilot

Ruby on Pilot is a lightweight MVC framework inspired by the functionality of Rails. The features in this framework include:

* An ORM inspired by `ActiveRecord`
* `Controller::Base` with basic functionality similar to `ActionController::Base` in Rails
* Routes and router
* Ability to implement `session`, `flash`, and `flash.now` cookies
* CSRF protection with a form authenticity token
* Middleware to show runtime errors
* Middleware to serve up static css assets

Additionally, a Rack application was created to handle runtime errors, with a view which displays the exception message, stack trace, and source code preview.

![MusicApp preview](musicapp.png)

The core code is located in the lib/ directory.

# Usage

* Clone the repository
* Install gems with `bundle install`
* To test the runtime errors middleware, run `ruby bin/runtime_error_test.rb` and go to `localhost:3000`
* To test the working server and router, run `ruby bin/server.rb` and go to `localhost:3000`

# Features

## `ControllerBase`

The `ControllerBase` contains functionality shared across controllers. See `lib/controller_base.rb' for more detail.

Notable features:
* Prevents double render errors with `already_built_response?`
* Handles redirects, and provides the appropriate status code
* Renders content using ERB
* Handles cookie functionality

## `Session` & `Flash`
`Session` and `Flash` use cookies to store data. Cookies are retrieved from the request (if they exist) via `initialize`, and passed to the response via `#store_cookie`. In this pattern, data can be persisted across request / response cycles.

`Session` cookies merely pass a session token via cookies. However. `Flash` has the unique property of only persisting for one cycle. `Flash` cookies are stored, displayed in the next cycle, and not persisted.

This is achieved by only ever persisting updated cookie data from the current cycle -- data from the previous cycle is never stored.

    def []=(key, val) # we only ever want to set values for the new cookie -- old cookie data is never passed on. See comment @ 11!
      @new_cookie_data[key] = val
    end

    def store_cookie(res) # save new_cookie_data
      res.set_cookie(@cookie_name, { path: '/', value: @new_cookie_data.to_json})
    end

One common use of `Flash` is for error messages -- it does not make sense to persist error messages across cycles, after which the error message is no longer relevant.

## Router & Routing
`Route`s are initialized with a regex pattern, a HTTP method, the class of its controller, and an action.
* The regex pattern is used to match the URI. This is matched to request paths (`req.path`) to pull out route parameters.
* The action corresponds to methods in the controller, e.g. `index`, `show`, etc. When a `Route` is run, this action is invoked in the controller assigned to the route.

The `Router` is responsible for creating `Route`s, and is represented by an array of `Route`s.

Ruby metaprogramming techniques are used to efficiently implement RESTful routing:

      [:get, :post, :put, :delete].each do |http_method|
        define_method(http_method) do |pattern, controller_class, action_name|
          add_route(pattern, http_method, controller_class, action_name)
        end
      end

An example of usage of the router can be found in `server.rb`. The relevant code follows:

First, a generic `Controller` is generated, with one method `#index`. This merely renders `HELLO WORLD`.

    class Controller < ControllerBase
      def index
        render_content("HELLO WORLD", "text/html")
      end
    end

Next, a `Router` is instantiated, and is used to create a route that tells the connected `Controller` to call `#index` when the regex pattern is matched.

    router = Router.new
    router.draw do
      get Regexp.new("^/index$"), Controller, :index
    end

## Runtime error handling
The error handler middleware implements three features to assist in debugging.

`#stack_trace` and `#exception_msg` simply display the backtrace and message of rescued exceptions.
`#source_code` uses a Regex pattern to pull out the path of the problematic file and the line number of the code that threw the exception. Then, opens the file and reads the problematic line and surrounding lines for context.

    def source_code # pull out problematic code, and preceding / following lines
      pattern = Regexp.new("^(?<path>.*rb):(?<line_num>\\d+).*$")
      capture = pattern.match(@e.backtrace[0])
      path = capture[:path]
      line_num = capture[:line_num].to_i - 1
      file = File.readlines(path)

      file[line_num - 3..line_num + 3]
    end

The user is then redirected to `runtime_error.html.erb`, where the preceding information is displayed.

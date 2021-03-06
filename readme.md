![VERSION!](https://img.shields.io/pub/v/forcemvc.svg) [![Build Status](https://drone.io/github.com/ForceUniverse/dart-forcemvc/status.png)](https://drone.io/github.com/ForceUniverse/dart-forcemvc/latest)

### Dart Force MVC ###

![LOGO!](https://raw.github.com/ForceUniverse/dart-force/master/resources/dart_force_logo.jpg)

Serverside MVC based implementation for Dart. Easy to setup and part of the dart force framework!

#### Introduction ####

Dart ForceMVC is a dartlang web framework, with a lot of similarities to java spring mvc

First of all you need to setup a web server:

```dart
library x;
import 'package:wired2/wired2.dart';
import 'package:forcemvc2/forcemvc2.dart';

part 'controllers/x_controller.dart';

main() {
  WebApplication app = new WebApplication(startPage: "start.html");
  
  app.start(); 
}
```

And then of course we need to create our controller.

```dart
part of x;

@Controller
class XController {

  @RequestMapping(value: "/home", method: "GET")
  String home(Locale locale, Model model) {
    model.addAttribute("someprop", "value" );
    
    return "home";
  }
  
}
```

In the web folder of your application you can create a home.html file. That will be your view.

#### Walkthrough ####

Use a Web Application Server with dart very easily, create controllers with annotations ... similar to java spring mvc.

First you will setup a new web application.

	WebApplication app = new WebApplication(wsPath: wsPath, port: port, host: host, buildPath: buildPath);
	
Then you use the 'use' method to handle http requests.

	app.use(url, (ForceRequest req, Model model) { /* logic */ }, method: "GET");
	
You can also use the annotation RequestMapping in a dart object

	@RequestMapping(value: "/someurl", method: "GET")
	void index(ForceRequest req, Model model)
	
You can also use the annotation @ModelAttribute to add an object to all the scopes in the methods.
An @ModelAttribute on a method argument indicates the argument should be retrieved from the model. If not present in the model, the argument should be instantiated first and then added to the model. Once present in the model, the argument's fields should be populated from all request parameters that have matching names.

	@ModelAttribute("someValue")
	String someName() {
		return mv.getValue();
	}
	
Then you register that object on the WebApplication object.

	app.register(someObjectWithRequestMappingAnnotations)
	
Or you can annotate a class with @Controller and then it will be registered automatically in the force WebApplication.

	@Controller
	class SomeObject {
	
	}

#### Starting your web application ####

You can do this as follow!

	app.start();
	
It is also possible to start a web application with SSL possibilities.

	app.startSecure();

#### ForceRequest ####

ForceRequest is an extension for HttpRequest

	forceRequest.postData().then((data) => print(data));
	
#### Interceptors ####

You can define inteceptors as follow, the framework will pick up all the HandlerInterceptor classes or implementations.

	class RandomInterceptor implements HandlerInterceptor {
  
	  bool preHandle(ForceRequest req, Model model, Object handler) { return true; }
	  void postHandle(ForceRequest req, Model model, Object handler) {}
	  void afterCompletion(ForceRequest req, Model model, Object handler) {}
	  
	}

#### Path variables ####

You can now use path variables in force mvc.

	@RequestMapping(value: "/var/{var1}/other/{var2}/", method: "GET")
	void pathvariable(ForceRequest req, Model model, String var1, String var2)

This is an alternative way how you can access path variables.

	req.path_variables['var1']

You can also use the annotation @PathVariable("name") to match the pathvariable, like below:

	  @RequestMapping(value: "/var/{var1}/", method: "GET")
	  String multivariable(req, Model model, @PathVariable("var1") variable) {}

#### Redirect ####

You can instead of returning a view name, performing a redirect as follow:

	@RequestMapping(value: "/redirect/")
  	String redirect(req, Model model) {
    	redirect++;
    	return "redirect:/viewable/";
  	}
  	
#### Asynchronous Controller ####

In the controller you can have asynchronous methods to handle for example POST methods much easier.

On the ForceRequest object you have a method .async and his value is the return value that matters for the req.

When a method is asynchronous you must return req.asyncFuture.

This is an example how you can use it.

	@RequestMapping(value: "/post/", method: "POST")
	Future countMethod(req, Model model) {
	     req.getPostParams().then((map) {
	       model.addAttribute("email", map["email"]);
	       
	       req.async(null);
	     });
	     model.addAttribute("status", "ok");
	     
	     return req.asyncFuture;
	}

#### Authentication ####

You can now add the annotation @Authentication to a controller class. 
This will make it necessary to for a user to authenticate before accessing these resources.

An authentication in force is following a strategy.
You can set a strategy by extending the class SecurityStrategy.

	class SessionStrategy extends SecurityStrategy {
	  
	  bool checkAuthorization(HttpRequest req, {data: null}) {
	    HttpSession session = req.session;
	    return (session["user"]!=null);
	  }   
	  
	  Uri getRedirectUri(HttpRequest req) {
	    var referer = req.uri.toString();
	    return Uri.parse("/login/?referer=$referer");
	  }
	} 
	
And then add this strategy to the web application.

	app.strategy = new SessionStrategy();
	
##### Roles #####

You can also define authorize roles. This can be done as follow.

	@Controller
	@PreAuthorizeRoles(const ["ADMIN"])
	class AdminController {
			
	}

##### ExceptionHandler #####

This helps in defining methods that will be executed when an error or exception occured. 

	@ExceptionHandler()
  	String error_catch(req, Model model) {
  		...
  	}

You can also specify a type, only when an error or exception happend of that Type, that method will be executed.

	@ExceptionHandler(type: DoorLockedError)
  	String doorLockedError(req, Model model) {
    	model.addAttribute("explanation", "This is a specific error!");
    	return "error";  
  	}

#### Logging ####

You can easily boostrap logging.

	app.setupConsoleLog();

#### Wired ####

Wired is a dependency injection package.
You can use @Autowired and @bean and more in forcemvc find info [here](https://github.com/ForceUniverse/dart-force_it)

#### LocaleResolver ####

In ForceMVC you have a locale resolver to handle locale. 
The implementation that is been used by default is the AcceptHeaderLocale Resolver, this resolver looks at the request header accept-language.

You can choose for a fixed locale resolver implementation or a cookie locale resolver or just implement your own handling if need.

#### View / Templating ####

In forcemvc you can define view templates. ForceMvc will look into the viewfolder and in the client 'build' folder for a .html file with the viewname that you provide the system in the controller.

	@RequestMapping(value: "/hello/")
  	String redirect(req, Model model) {
    	// do something
    	model.addAttribute("text", "greetings");
    	return "hello";
  	}
 
So in the example about we are returning a string with the value 'hello'. So the system will search in the view & build folder for a hello.html file.

The default implementation in ForceMVC for templating is mustache. 

In the html file {{text}} will be replaced by greetings.

More info about creating your own viewrender implementation [here](https://github.com/ForceUniverse/dart-forcemvc/wiki/Create-your-own-viewrender)

#### Development trick ####

Following the next steps will make it easier for you to develop, this allows you to adapt clientside files and immidiatly see results with doing a pub build.

	pub serve web --hostname 0.0.0.0 --port 7777 &&
	export DART_PUB_SERVE="http://localhost:7777" &&
	pub run bin/server.dart
	
#### GAE ####

You can now easily run your Force apps on a Google App Engine infrastructure by the following code! The rest is the same as a normal dart force app.

  WebApplication app = new WebApplication();
    
  runAppEngine(app.requestHandler).then((_) {
      // Server running. and you can do all the stuff you want!
  });
  
You don't need to start WebApplication anymore, the start of the server will be done by AppEngine!

More info about [GAE overall](https://www.dartlang.org/cloud/) 

#### Rest API's ####

If you want to learn more about how to build Rest api's with ForceMVC go [here](https://github.com/ForceUniverse/dart-forcemvc/tree/master/example/server/controllers/rest)

#### Example ####

You can find a simple example with a page counter implementation [here](https://github.com/jorishermans/dart-forcemvc-example) - [live demo](http://forcemvc.herokuapp.com/)

Or visit Github issue mover [here](https://github.com/google/github-issue-mover)

#### Youtube ####

You can watch a simple youtube video to get you started, have an idea between the transformation of java spring mvc and force mvc [here](https://www.youtube.com/watch?v=AcwnoiYEv8I)

#### TODO ####

- get more annotations and options for sending the response back
- writing tests
 
### Notes to Contributors ###

#### Fork Dart Force MVC ####

If you'd like to contribute back to the core, you can [fork this repository](https://help.github.com/articles/fork-a-repo) and send us a pull request, when it is ready.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/) first.

#### Dart Force ####

Realtime web framework for dart that uses force MVC & wired [source code](https://github.com/ForceUniverse/dart-force)

#### Twitter ####

Follow us on twitter https://twitter.com/usethedartforce

#### Google+ ####

Follow us on [google+](https://plus.google.com/111406188246677273707)

#### Join our discussion group ####

[Google group](https://groups.google.com/forum/#!forum/dart-force)

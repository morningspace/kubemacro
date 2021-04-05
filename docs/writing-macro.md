## Writing Macro

KubeMacro does not bundle pre-defined macros. You can explore and install macro shared by other people from [KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/). To learn more on this, please read [KubeMacro Hub](kubemacro-hub.md).

If the existing macros can not fullfil your requirement, you can also write your own macro. This document will work you through the steps to write a macro and make it recognized by KubeMacro. Meanwhile, you are very welcome to submit your macro to KubeMacro Hub so that other people can be benefit from your work too. To learn more on how to contribute to KubeMacro Hub, please read [Contributing](contributing.md).

As an example, let's write a macro to print a list of pods with their containers.

### Create a shell script file

Let's create a shell script file called `get-pod-containers.sh` and put it into `$HOME/.kubemacro` directory. This is where KubeMacro loads the macros. Each time when KubeMacro is started, it will find all `.sh` files in this directory and load them as macros.

The macro in the file is implemented as a shell function. In your case, it is the function `get-pod-containers` and right now the function body is empty:
```shell
#!/bin/bash

function get-pod-containers {
  :
}
```

To test the macro, run `kubectl macro`, specify the funtion name `get-pod-containers` as the macro name:
```shell
kubectl macro get-pod-containers
```

You will see nothing returned as expected. Next, let's add something real to the function.

### Implement the macro

Here is the logic added to the `get-pod-containers` function:
```shell
#!/bin/bash

function get-pod-containers {
  local args=()
  local ns=''
  # Parse the arguments input from command line
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace|-n=*|--namespace=*)
      ns=$2
      args+=("$1 $2")
      shift
      shift ;;
    -A|--all-namespaces)
      ns="all namespaces"
      args+=("$1")
      shift ;;
    *)
      args+=("$1")
      shift ;;
    esac
  done
  # Run kubectl get and define custom columns to include pod container names
  local custom_columns="NAME:.metadata.name,CONTAINERS:.spec.containers[*].name"
  if [[ $ns == "all namespaces" ]]; then
    custom_columns="NAMESPACE:.metadata.namespace,$custom_columns"
  fi
  kubectl get pods ${args[@]} -o custom-columns=$custom_columns
}
```

Basically, it does two things:
* Parse the arguments input from command line.
* Run `kubectl get` and define custom columns to include the pod container names extracted from pod definition using JSONPath `.spec.containers[*].name`.

Now let's run the macro. This will list all pods with their containers in current namespace:
```shell
kubectl macro get-pod-containers
```

### Add comment to the macro

So far you have implemented your macro. Pretty easy right? But there is one more thing left. To make the macro visible in the installed macro list when you run KubeMacro with `-h/--help` option or without any option, you need to add one special comment ahead of the macro function.

Also, when you run `kubectl macro <macro>` with `-h/--help` option to print the help information for your macro, it requires you to prepare the help information beforehand. This is also defined in the comment.
  
Moreover, if you want to share your macro to other people via KubeMacro Hub, to define more detailed help information for your macro is also a must-have.

The comment should start with `##` and end with `##`, inside which there are a few fields where the field names are all started with `@`. Below is a template with detailed explanation for each field:
```shell
##
# @Name: <Input your single-line macro name here>
# @Description: <Input your single-line macro description here>
# <Input detailed description for your macro started from here>
# <It supports multiple lines and markdown syntax>
# @Author: <Input single-line author name here, support markdown syntax>
# @Usage: <Input your single-line macro usage information here>
# @Options:
#   <Input help information for all your options started from here>
#   <It supports multiple lines>
# @Examples:
#   <Input detailed information for all examples started from here>
#   <It supports multiple lines>
# @Dependencies: <Input single-line comma-separated dependencies of your macro here>
##
```

Here is the comment for the `get-pod-containers` macro:
```shell
##
# @Name: get-pod-containers
# @Description: List the pods with their containers.
#
# This is a sample macro to demonstrate how to write a macro by your own.
#
# It can be used to list a set of pods with their containers.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-containers [options]
# @Options:
#   -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
#   context is ignored even if specified with --namespace.
#   -h, --help: Print the help information.
#   -n, --namespace='': If present, the namespace scope for this CLI request.
#   -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
#       --version: Print the version information.
#   -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
#   if no object name is provided.
#       --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.
# @Examples:
#   # To list all pods with their containers in a namespace.
#   kubectl macro get-pod-containers -n foo
#   # To list all pods with their containers in all namespaces.
#   kubectl macro get-pod-containers -A
# @Dependencies: kubectl
##
function cluster {
  ...
}
```

To validate it, run below command to see if the macro is included in the installed macro list:
```shell
kubectl macro --help
```

If all goes as expected, you will see `get-pod-containers` appeared in the list. Run below command to print the help information for the macro:
```shell
kubectl macro get-pod-containers --help
```

You will see below output which is exactly what we define in the comment as above:
```
get-pod-containers: List the pods with their containers.

Usage: kubectl macro get-pod-containers [options]

Options:
  -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
  context is ignored even if specified with --namespace.
  -h, --help: Print the help information.
  -n, --namespace='': If present, the namespace scope for this CLI request.
  -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
      --version: Print the version information.
  -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
  if no object name is provided.
      --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.

Examples:
  # To list all pods with their containers in a namespace.
  kubectl macro get-pod-containers -n foo
  # To list all pods with their containers in all namespaces.
  kubectl macro get-pod-containers -A
```

### Macro dependencies

You many notice the `@Dependencies` definition in the above comment. Macro may have dependencies. For example, some macro needs `jq` to parse JSON data, some macro may depend on other macro to complete the work. To run a macro, it requires its dependencies to be available at first.

When you write a macro, you can define its dependencies as needed. When KubeMacro runs a macro, it will check if it has any dependency. If it does, KubeMacro will then check the existence of the dependencies and report error if any dependency is not available.

### Put all things together

To put all things together, the final version of the `get-pod-containers` macro can be found as below:

[filename](assets/get-pod-containers.sh ':include :type=code shell')

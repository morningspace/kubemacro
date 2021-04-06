## Getting Started

### Install KubeMacro

#### Install as standalone command

It is easy to install KubeMacro since it is just a script. You can download it from KubeMacro [GitHub repository](https://github.com/morningspace/kubemacro/) then make it executable as below:
```shell
curl -L https://raw.githubusercontent.com/morningspace/kubemacro/master/kubectl-macro.sh -o kubectl-macro
chmod +x kubectl-macro
```

To validate the installation:
```shell
./kubectl-macro
```

If everything works as expected, you will see the KubeMacro general help information.

#### Install as kubectl plugin

Although KubeMacro can be run as a standalone command from the command line, it is recommended to run it as [kubectl plugin](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/) since it is the most intuitive way to run KubeMacro. To run KubeMacro as a kubectl plugin, the only thing you need to do is to place the `kubectl-macro` script anywhere in your `PATH`. For example:
```shell
mv ./kubectl-macro /usr/local/bin
```

You may now invoke KubeMacro as a kubectl command:
```shell
kubectl macro
```

This will give you exactly the same output as above when you run the script in standalone mode.
<!--
#### Install using Krew

KubeMacro has been submitted to [krew](https://krew.sigs.k8s.io/) as a kubectl plugin distributed on the centralized [krew-index](https://krew.sigs.k8s.io/plugins/), so you can install KubeMacro directly using krew as well:
```shell
krew install macro
```
-->
### Install a macro

After install KubeMacro, you need to install specific macro to complete Kubernetes routine tasks. By default, there is no macro pre-bundled with KubeMacro. By visiting [KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/), a website that hosts awesome macros shared by other people, you can explore these macros and install any one as you like. To learn more on KubeMacro Hub, please read [Using KubeMacro Hub](using-kubemacro-hub.md).

Certainly you can write your own macro and contribute to KubeMacro Hub as well. To learn how to write your own macro, please read [Writing a Macro](writing-a-macro.md). To learn how to contribute, please read the [Contributing](contributing.md) guidance.

Here are some recommanded macros that you can start with:

| Macro             | Description
|:------------------|:-----------------------------
| get-apires        | Get API resources in a namespace.
| get-by-owner-ref  | Get resource in a namespace along with its ancestors via owner references.
| get-pod-by-svc    | Get all pods associated with a service.
| get-pod-not-ready | Get the pods that are not ready.
| get-pod-restarts  | Get the pods that the restart number matches specified criteria.
| get-pod-status    | Get the pods that pod status matches specified criteria.

In this document, let's use `get-pod-by-svc` as an example to demonstrate how to install a macro.

To install a macro is fairly easy. You can go to the macro page on KubeMacro Hub, in your case, [get-pod-by-svc](https://morningspace.github.io/kubemacro-hub/macros/#/docs/get-pod-by-svc), switch to the `Code` tab, follow the instructions on the tab to click the download link, or to copy the code into a local file named as `get-pod-by-svc.sh`, put it in `$HOME/.kubemacro` directory. That's it. KubeMacro will scan the directory and pick up all macros installed underneath.

After install the macro, to validate the installation:
```shell
kubectl macro get-pod-by-svc --help
```
You will see the help information that is specific to this macro.

Besides the help information displayed from the command line, you can also check the `Description` tab on the macro page on KubeMacro Hub where it gives you more information on what this macro is for and how to use it.

### Upgrade a macro

The macro authors can update their macros for some reasons, for example, to introduce a new feature or to fix a bug. If you have already installed a macro, there needs to be a way for you to get the latest copy if the macro has been updated by the author.

KubeMacro does not have a concept of macro version, but it will calculate the shasum of a macro for its local copy when it is run, and compare the value for the remote copy hosted on [KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/). If it is different, a warning message will be displayed. Then, you can go to check the corresponding macro page on KubeMacro Hub and decide whether or not to update your local copy to the latest one.

To make comparison using the shasum value can also gaurantee that the macro you are using is exactly the identical copy published on KubeMacro Hub.

Now that you have learned how to install KubeMacro, install and upgrade macros, it is recommended to go to [KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/), look around for the macros that you are interested in, then pick up one or two to install and use. Enjoy yourself!
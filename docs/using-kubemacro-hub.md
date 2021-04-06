## Using KubeMacro Hub

### What is KubeMacro Hub

[KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/) is designed as a central place for people to exchange their awesome `kubectl` macros across the Kubernetes community. You can explore the amazing macros created by other developers, or share your own cool macros to other users via KubeMacro Hub.

This document will work you through way on how to explore macros hosted on KubeMacro Hub. You can also contribute your own macros by submitting pull request to the [GitHub repository](http://github.com/morningspace/kubemacro-hub) of KubeMacro Hub. To learn mroe on:
* How to write a macro, please read [Wrting Macro](writing-macro.md).
* How to contribute to KubeMacro Hub, please read [Contributing](contributing.md).

### Explore KubeMacro Hub

After you open [KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/), you will see a list of available macros on the left side of the page. You can choose either of them by clicking the macro name to go to the specific page for this macro on the right side. There is also a search box at the top left, where you can search macros by typing words in the box. Browse the search results then choose one of the entries. It will bring you to a macro page.

On the macro page, you will see the macro name and a short description on the top.

Besides that, there are a few tabs as below. Click each tab and view the description with sample contents to understand how they are organized. For the sample contents, it comes from the sample macro introduced in [Writing Macro](writing-macro.md).

<!-- tabs:start -->

#### **Description**

?> On `Descriptin` tab, you will see the detailed information on this macro, such as what this macro is for, how to use it, and so on.

This is a sample macro to demonstrate how to write a macro by your own. It can be used to list pods and their containers. For example, to list all pods and their containers in `kube-system` namespace:
```shell
kubectl macro get-pod-containers -n kube-system
NAME                                         CONTAINERS
coredns-6955765f44-gtx2q                     coredns
coredns-6955765f44-tz96m                     coredns
etcd-kind-control-plane                      etcd
kindnet-4pzm7                                kindnet-cni
kube-apiserver-kind-control-plane            kube-apiserver
kube-controller-manager-kind-control-plane   kube-controller-manager
kube-proxy-b6wn8                             kube-proxy
kube-scheduler-kind-control-plane            kube-scheduler
```

#### **Usage & Options**

?> On `Usage & Options` tab, it will show the usage information of this macro, and all the options that it supports.

**Usage**

kubectl macro get-pod-containers [options]

**Options**

```
 -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
 context is ignored even if specified with --namespace.
 -h, --help: Print the help information.
 -n, --namespace='': If present, the namespace scope for this CLI request.
 -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
 -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
 if no object name is provided.
     --version: Print the version information.
     --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.
```

#### **Examples**

?> On `Examples` tab, there will be some examples that you can take as reference to understand how to use this macro in practice.

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To list all pods with their containers in a namespace.
kubectl macro get-pod-containers -n foo
# To list all pods with their containers in all namespaces.
kubectl macro get-pod-containers -A
```

#### **Dependencies**

?> On `Dependencies` tab, it will list all the dependencies of this macro if there is any. To run the macro, it requires all its dependencies to be installed at first. To learn more on macro dependencies, please read the [Macro dependencies](writing-macro.md#macro-dependencies).

To run this macro, it requires below dependencies to be installed at first:

* kubectl

#### **Code**

?> On `Code` tab, you can view the source code of this macro to understand how it works. Also, it has instructions on how to install the macro. To learn more on macro installation, please read [Install a macro](installation.md#install-a-macro).

To install this macro, you can download it [here](assets/get-pod-containers.sh ':ignore get-pod-status'), or copy the following code into a local file named as `get-pod-containers.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](assets/get-pod-containers.sh ':include :type=code shell')

<!-- tabs:end -->

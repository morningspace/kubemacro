## Introduction

### What is KubeMacro?

KubeMacro is designed as a kubectl plugin to run kubectl macro (macro for short) that wraps a set of kubectl calls into one command that you can run from the command line as many times as you want.

Let's see some examples how KubeMacro can help when you work with Kubernetes clusters using kubectl.

#### Example 1: Restart pods accosiated with a Kubernetes service

If you want to restart all pods that are associated with a Kubernetes service, you may have to do the following steps one after another:
* Inspect the Kubernetes service and check the `.spec.selector` field.
* Use the lables defined in the `.spec.selector` field to query the pods associated with the service.
* Delete the pods so that Kubernetes can spin up new pods for you.

It is tedious, also inefficient, to repeat these steps manually every time when you need to restart such pods.

#### Example 2: Delete a namespace stuck in terminating status

To delete a namespace that is stuck in `Terminating` status is not a trivial task as you might imagine. You will need to understand:
* Why the namespace keeps terminating.
* Whether you should enumerate API resources in this namespace and delete them at first before you try to force delete the namespace.
* If we decide to force delete, how to get it done by removing the namespace finalizers.

All these topics deserve a dedicated document including step by step instructions with caveates.

### Using KubeMacro

As you can see, when work with clusters using kubectl to complete routine tasks, it is common that many of these tasks can not be done by just executing one or two kubectl commands. Some of them are complicated enough that require to be documented.

The idea of KubeMacro is quite straightforward. It encapsulates one or more kubectl calls into an executable block, a shell function, with some best practices embedded, and call it as kubectl macro (or macro for short). Each macro is aimed to address a specific problem and usually one or more kubectl calls will be involved with some additoinal code logic around in order to complete the task.

By using a macro, you can run it as a single unit of work as many times as you want. This allows you to work with your Kubernetes cluster more efficiently and less error prone.

Now that you have learned what KubeMacro is, you may be interested in how to install and run it with kubectl macros by reading [Getting Started](getting-started.md).
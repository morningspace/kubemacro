# KubeMacro Hub

## What is KubeMacro Hub

[KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/) is designed as a central place for people to exchange their awesome `kubectl` macros across the Kubernetes community. You can explore the amazing macros created by other developers, or share your own cool macros to other users via KubeMacro Hub.

This document will work you through way on how to explore macros hosted on this Hub and how to install them.

## Explore KubeMacro Hub

After you open [KubeMacro Hub](https://morningspace.github.io/kubemacro-hub/), you will see a list of available macros on the left side of the page. You can choose either of them by clicking the macro name to go to the specific page for this macro on the right side. There is also a search box at the top left, where you can search macros by typing words in the box.

On the macro page, besides the macro name and a short description on the top, there are 5 tabs:

<!-- tabs:start -->

### **Description**

On `Descriptin` tab, you will see the detailed information on this macro, such as what this macro is for, how to use it, and so on.

### **Usage & Options**

On `Usage & Options` tab, it will show the usage information of this macro, and all the options that it supports.

### **Examples**

On `Examples` tab, there will be some examples that you can take as reference to understand how to use this macro in practice.

### **Dependencies**

On `Dependencies` tab, it will list all the dependencies of this macro if there is any. To run the macro, it requires its dependencies to be installed at first.

To learn more on macro dependencies, please read the [Macro dependencies](#macro-dependencies) section on this page.

### **Code**

On `Code` tab, you can view the source code of this macro to understand how it works. Also, it has instructions on how to install the macro.

To learn more on macro installation, please read [Install a macro](installation.md#install-a-macro).

<!-- tabs:end -->

## Macro dependencies

Macro may have dependencies. For example, some macro needs `jq` to parse JSON data, some macro may depend on other macro to complete the work. To run a macro, it requires its dependencies to be available at first.

When you write a macro, you can define its dependencies as needed. When KubeMacro runs a macro, it will check if it has any dependency. If it does, KubeMacro will then check the existence of the dependencies and report error if any dependency is not available.

To learn how to define dependency for a macro, please read [Writing Macro](wrint-macro.md).

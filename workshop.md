# LINK 2017 Workshop: _Building UI with Web Skin Dart_

**Presenter:** Greg Littlefield

This workshop will provide a comprehensive walkthrough of building a UI using Web Skin Dart, with tips and best practices sprinkled in.

We'll start by building a simple layout composed of existing components, and incrementally build and introduce complex custom components.

Along the way we’ll cover the details of component lifecycle, event handling, debugging using the Chrome and React DevTools, and unit testing of UI.

- Recording _(not yet available)_
- [Slides](https://docs.google.com/presentation/d/12mF9Brti63bRpxqLWgFauFr3EkrDPl9GKF_-fP-95E0/edit#slide=id.g2058bc8d9b_0_39)
- HipChat room: [`LINK 2017: Building UI with WSD`](hipchat://workiva.hipchat.com/room/3784466)
    - Need support? Have questions? Ask here, and our team will help you out!
    - Have feedback after the workshop? Leave it here!
- Repo: [todo-example-client](https://github.com/Workiva/todo-example-client/tree/ui-workshop/start) (this repo)
    - instructions at [_Setting up on your machine_](#setting-up-on-your-machine)
- Other info:
    - OverReact component snippets and boilerplate: [workshop/snippets.md](./workshop/snippets.md)
    - Web Skin Dart and OverReact tips and best practices: [workshop/best_practices.md](./workshop/best_practices.md)

## How is this workshop going to work?
In this workshop, we'll be tasked with building a UI into an existing repo, within an existing Wdesk experience. w_flux actions and stores are in place, so it'll just be a matter of building UI and wiring it up.

This workshop is formatted as a hybrid presentation and guided codelab. I'll be walking through the process from start to finish, implementing code in an on-screen IDE and using slides to help communicate tips, processes, and other information.

The different steps in the development process are available as branches (see [_Workshop Agenda_](#workshop-agenda) for more info), allowing you to follow along on your own machine, and even skip ahead if you ~~get bored~~ are ambitious.

## Setting up on your machine
- If you haven't done so already check out [Introduction To Dart](https://dev.workiva.net/docs/github/workiva/applicationframeworks/dartintroduction) and install Dart on your machine.

- Open up a browser tab with the [Web Skin Dart Docs](https://docs.workiva.org/web_skin_dart/latest/components/) so that we can quickly reference them later.

- Clone the repo, check out the workshop's first commit, and fetch dependencies.
    ```bash
    git clone git@github.com:Workiva/todo-example-client.git
    cd todo-example-client
    
    git checkout ui-workshop/start
    
    pub get --packages-dir
    ```
    
    **Make sure to be on the Workiva-LINK17 network, or `pub get` won't work.**

- Serve the app using `pub serve`, open it in Dartium by navigating to <http://localhost:8080/>, and auth using wk-dev's Single Sign-On.

- If nothing went wrong, you should see "Hello world!" within an empty Workspaces shell.

## Workshop Agenda

Listed below are the tasks we'll be performing in this workshop.

> Each step (starting with 2a), is associated with two branches, which correspond the state of the codebase _before_ and _after_ the task has been completed.
>
> [All branches](https://github.com/Workiva/todo-example-client/branches/all?query=ui-workshop%2F) are prefixed with `ui-workshop/` and the task numbering, for convenience.
>
> For example, step 4b is associated with branches `ui-workshop/4b-item-component` and `ui-workshop/4b-item-component_done`


1. Review the visual spec

2. Build the layout
    - a. Lay out content as intended

3. Compose basic UI with WSD - Display todos
    
4. Break up our UI into components
    - a. Split up main app view:
        - i. TodoList 
        - ii. Create todo input
    - b. Todo list items

5. Flesh out component functionality - TodoListItem 
    - a. Add completion checkbox 
    - b. Display notes 
    - c. Wire up expanded behavior 
    - d. Display privacy badge 
    - e. Wire up actions buttons 

6. EditTodoModal component 

7. Polish TodoListItem
    - a. Basic conditional rendering 
    - b. Disable buttons based on permissions 
    - c. Fine-tune block layout padding 
    - d. Custom class names 
    - e. Hide toolbar unless hovered/focused     

8. Unit tests

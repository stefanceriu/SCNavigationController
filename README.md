# SCNavigationController

SCNavigationController is an UINavigationController like container view controller and was built to provide and expose more features and control. It is especially helpful in customizing the push/pop animations through layouters and custom timing functions, and to know when those animations are finished through completion blocks. 

It was built on top of the [SCStackViewController](https://github.com/stefanceriu/SCStackViewController) and for that reason it supports and builds on top of the following features:

1. Supports customizable transitions and animations through custom layouters, easing functions and animation durations (examples bellow)
2. Offers completion blocks for all stack related operations
3. Allows stacking view controllers on the top, left, bottom or right side of the root view controller
4. Exposes an interactiveGestureRecognizer not just for popping but for full stack navigation and allows changes on this gesture's trigger area

    and more..

## Examples

##### Parallax - Sine Ease In Out - Right

![Parallax - Sine Ease In Out - Right](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCNavigationController/Parallax%20-%20Sine%20Ease%20In%20Out%20-%20Right.gif)

##### Parallax - Sine Ease In Out - Top

![Parallax - Sine Ease In Out - Top](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCNavigationController/Parallax%20-%20Sine%20Ease%20In%20Out%20-%20Top.gif)

##### Parallax - Interactive

![Parallax - Interactive](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCNavigationController/Parallax%20-%20Interactive.gif)

##### Plain - Elastic Ease Out

![Plain - Elastic Ease Out](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCNavigationController/Plain%20-%20Elastic%20Ease%20Out.gif)

##### Sliding - Bounce Ease Out

![Sliding - Bounce Ease Out](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCNavigationController/Sliding%20-%20Bounce%20Ease%20Out.gif)

##### Parallax - Back Ease In Out

![Parallax - Back Ease In Out](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCNavigationController/Parallax%20-%20Back%20Ease%20In%20Out.gif)

##### Google Maps - Back Ease In

![Google Maps - Back Ease In](https://dl.dropboxusercontent.com/u/12748201/Recordings/SCNavigationController/Google%20Maps%20-%20Back%20Ease%20In.gif)

## Usage

- Import the navigation controller into your project

```
#import "SCNavigationController.h"
```

- Create a new instance

```
navigationController = [[SCNavigationController alloc] initWithRootViewController:rootViewController];
```
 
- Register layouters (optional, defaults to SCParallaxStackLayouter)

```
id<SCStackLayouterProtocol> layouter = [[SCParallaxStackLayouter alloc] init];
[navigationController setLayouter:layouter];
```

- Push view controllers

```
[self.navigationController pushViewController:viewController animated:YES completion:nil];
```

- Pop view controllers

```
[self.navigationController popViewControllerAnimated:YES completion:nil];
```

- Pop to any given view controller

```
[self.navigationController popToViewController:viewController animated:YES completion:nil];
```

- Pop to the root view controller

```
[self.navigationController popToRootViewControllerAnimated:YES completion:nil];
```

######Check out the demo project for more details (pod try)

## License
SCNavigationController is released under the MIT License (MIT) (see the LICENSE file)

## Contact
Any suggestions or improvements are more than welcome.
Feel free to contact me at [stefan.ceriu@yahoo.com](mailto:stefan.ceriu@yahoo.com) or [@stefanceriu](https://twitter.com/stefanceriu).
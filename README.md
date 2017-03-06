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

![Parallax - Sine Ease In Out - Right](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoVFVNR1A2b0wwa1k)

##### Parallax - Sine Ease In Out - Top

![Parallax - Sine Ease In Out - Top](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoOVktTWRrSVV5ZDQ)

##### Parallax - Interactive

![Parallax - Interactive](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoZ1JYckpENk1WdkU)

##### Plain - Elastic Ease Out

![Plain - Elastic Ease Out](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoSTZudVo1T0o1dzQ)

##### Sliding - Bounce Ease Out

![Sliding - Bounce Ease Out](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoRHg0bkcwamE0LXc)

##### Parallax - Back Ease In Out

![Parallax - Back Ease In Out](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoZHN3S1V4b3RlZWc)

##### Google Maps - Back Ease In

![Google Maps - Back Ease In](https://drive.google.com/uc?export=download&id=0ByLCkUO90ltoZDVGTGlVeFZNUGM)

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

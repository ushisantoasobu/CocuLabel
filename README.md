# CocuLabel

CocuLabel is subclass of UILabel that changes text color optimaized back view.

## Features

![Alt Text](https://github.com/ushisantoasobu/CocuLabel/blob/master/cocu_demo.gif)

## Installation

not yet

## Usage

```swift
var label = CocuLabel()

label.updateColor()

// you can set priority three colors.
// if all colors don't satisfy, automatic optimized color is set
label.setPriorityColor(UIColor.whiteColor(),
            			second: UIColor.blackColor(),
            			third : UIColor.greenColor())
label.updateColor()
```

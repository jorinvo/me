---
title: "Edit Images on the Command Line With GraphicsMagick"
date: 2017-11-22T20:20:37+01:00
---

Let's explore how to fulfill your image editing needs right in the terminal.
<!--more-->

**Contents:**

- [Resizing](#resizing)
- [Cropping](#cropping)
- [Mirror Images](#mirror-images)
- [Combine Multiple Images Into One](#create-a-montage-by-combining-multiple-images-into-one)
- [Combine Images Into a PDF](#combine-images-into-a-pdf)
- [Change Images to Black & White](#change-images-to-black-white)

You are a software developer and spend a lot of your time with command line programs inside a terminal. Then once in a while you have to leave the comfort of your text-based world, go make coffee while waiting for Photoshop to load up, only to then make a quick change on some graphic. Wouldn't it be great if there would be a quick and easy way to do this from the comfort of your terminal? Drinking this much coffee is not healthy for you in any case.

Enter [GraphicsMagick](http://www.graphicsmagick.org/) — "the swiss army knife of image processing".

You might not have heard of GraphicsMagick before, but maybe you heard of [ImageMagick](https://www.imagemagick.org/), its older cousin. It knows a few more things. Or just different things. Also it is mostly slower. In any case you can switch switch between them pretty easily and all commands below should still sort of work.

Let's get started. First make sure you have GraphicsMagick installed. You can do so easily by running `brew install graphicsmagick` or `apt-get install graphicsmagick` or something similar for your operation system.

Don't get scared by the project's archaic website. The [documentation](www.graphicsmagick.org/GraphicsMagick.html) in there is in fact pretty decent. Of course you can also avoid opening a web browser and use `man gm` in your terminal instead. The binary to use GraphicsMagick for the command line is named `gm`.

For all examples we will use [this](https://unsplash.com/photos/Cey5ljV8R6A) image from Unsplash:

![Captain Dog](/images/gm/captain-dog.jpg)

### Resizing

Before we start, `gm` provides different sub-commands and  those take flags and arguments for configuration.
To do resizing we will use the `gm convert` command. Note that you can use `gm mogrify` with basically the same options, but `mogrify` overwrites
the given file while `convert` saves the results into a new file, which is definitely saver for our experiments.

To follow along, you can find the images in [this](https://github.com/jorinvo/me/tree/master/static/images/gm) folder.

First we run the following which tells us the dimensions of 600 by 400 pixels:

```
$ file captain-dog.jpg
captain-dog.jpg: JPEG image data, JFIF standard 1.01, resolution (DPI), density 72x72, segment length 16, baseline, precision 8, 600x400, frames 3
```

The simplest way to resize an image is to specify a new width. The height scales proportionally:

```sh
gm convert -resize 100 captain-dog.jpg dog-100.jpg
```

![Dog resized to 100px](/images/gm/dog-100.jpg)


Alternatively you can specify a width and a height, then the program will resize the images to fit into the new dimensions without changing the proportions:

```sh
gm convert -resize 200x100 captain-dog.jpg dog-200-100.jpg
```

![Dog resized to 200x100](/images/gm/dog-200-100.jpg)

```sh
gm convert -resize 100x200 captain-dog.jpg dog-100-200.jpg
```

![Dog resized to 100x200](/images/gm/dog-100-200.jpg)

You can also use percentage instead:

```sh
gm convert -resize 50% captain-dog.jpg dog-half.jpg
```

![Dog resized to 50%](/images/gm/dog-half.jpg)

Instead of changing the original image, you can also extend it to fill out the given dimensions:

```sh
gm convert -extent 100 -background red \
  dog-100-200.jpg dog-extend-100.jpg
```

![Dog extended to 100px](/images/gm/dog-extend-100.jpg)

Note that I also specified a background color. The [color format](http://www.graphicsmagick.org/GraphicsMagick.html#details-fill) is pretty similar to the way you might already know from CSS or other places. You can also set it to `transparent`.

If you need the image in the center you can do this by setting the gravity, but make sure to set it before setting `-extent` since GraphicsMagick applies the options in order:

```sh
gm convert -gravity center -extent 100 \
  -background red dog-100-200.jpg dog-extend-center.jpg
```

![Dog extended to 100px and centered](/images/gm/dog-extend-center.jpg)

Note that if you like to use a faster resizing algorithm you can use `-scale` instead of `-resize`.


### Cropping

Closely related to resizing, we often need to cut out a certain part of an image.

Let's crop the image to a square:

```sh
gm convert -crop 400x400 captain-dog.jpg dog-square.jpg
```

![Dog squared](/images/gm/dog-square.jpg)

Now the dog is cut off on the right side. Let's place the square in the center. To do this we need to do the calculation on our own and specify the offset in the crop dimensions:

```sh
gm convert -crop 400x400+150 \
  captain-dog.jpg dog-square-center.jpg
```

![Dog squared](/images/gm/dog-square-center.jpg)


This looks about right. Note that the different options can be combined and even repeated. The order is important:

```sh
gm convert -resize 200 -crop 400x400+150 \
  captain-dog.jpg dog-square-center-error.jpg
```

![Dog squared broken](/images/gm/dog-square-center-error.jpg)

This didn't work, but if we switch the arguments order, it looks correct:

```sh
gm convert -crop 400x400+150 -resize 200 \
  captain-dog.jpg dog-square-center-small.jpg
```

![Dog squared](/images/gm/dog-square-center-small.jpg)

Alternatively you can leave the order and change the dimensions instead:

```sh
gm convert -resize x200 -crop 200x200+75 \
  captain-dog.jpg dog-square-center-small2.jpg
```

![Dog squared](/images/gm/dog-square-center-small2.jpg)


### Mirror Images

You can mirror images on both axes:

```sh
gm convert -flop captain-dog.jpg dog-flop.jpg
```

![Dog flopped](/images/gm/dog-flop.jpg)

```sh
gm convert -flip captain-dog.jpg dog-flip.jpg
```

![Dog flipped](/images/gm/dog-flip.jpg)


### Create a Montage by Combining Multiple Images Into One

Images can be combined by using the `gm montage` command. You need to specify the result dimensions:

```sh
gm montage -geometry 600x400 \
  captain-dog.jpg dog-flop.jpg dog-montage.jpg
```

![Dog montage](/images/gm/dog-montage.jpg)

You can also leave a margin around the images:

```sh
gm montage -geometry 600x400+10+10 -background blue \
  captain-dog.jpg dog-flop.jpg dog-montage-margin.jpg
```

![Dog montage with margin](/images/gm/dog-montage-margin.jpg)

And you can modify the grid in which the images are places:

```sh
gm montage -tile 1x -geometry 300x200 \
  captain-dog.jpg dog-flip.jpg dog-montage-vertical.jpg
```

![Dog montage vertical](/images/gm/dog-montage-vertical.jpg)


### Combine Images Into a PDF

GraphicsMagick gives you a really quick way to combine a few images into a PDF:

```sh
gm convert captain-dog.jpg dog-flop.jpg dog-flip.jpg \
  dog.pdf
```

[Resulting PDF](/images/gm/dog.pdf)

There is not just PDF but over 88 supported formats from which and to which you can easily convert your graphic files.


### Change Images to Black & White

As last example, let's convert the image to black & white:

```sh
gm convert -monochrome captain-dog.jpg dog-bw.jpg
```

![Dog in black & white](/images/gm/dog-bw.jpg)

We can also convert it to greyscale by setting the saturation to zero:

```sh
gm convert -modulate 100,0 captain-dog.jpg dog-grey.jpg
```

![Dog in greyscale](/images/gm/dog-grey.jpg)


---------

As a bonus for Mac users, add the following function to [your .bashrc file](https://github.com/jorinvo/dotfiles/blob/master/bashrc) so you can simply type `ql captain-dog.jpg` to preview files:

```sh
# View file with Quick Look
ql() {
  qlmanage -p "$1" &>/dev/null
}
```

---------


This is just the beginning. You can do many more things with GraphicsMagick such as rotating images, [blending images](http://www.graphicsmagick.org/composite.html) with many options such as opacity, adjust the colors of images to your liking with options such as `-blur`, `-sharpen`, `-gamma` and `-modulate`, [batching](www.graphicsmagick.org/batch.html) commands to run many edit operations in one go or even create animated GIF images.

Of course now you also have the power to automate all your editing needs. You can write reusable shell scripts to edit many images at once or you can even use GraphicsMagick for all your production image editing jobs. There are bindings for every popular programming language — for example in [Node.js](https://github.com/aheckmann/gm).

Let me know about your favorite tools and your setup for editing images, both, manually and automated!

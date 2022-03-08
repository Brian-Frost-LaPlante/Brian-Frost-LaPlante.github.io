@def title = "brian l frost" 
@def tags = ["syntax", "code"]


## about me

~~~
<div class="row">
  <div class="container">
    <img class="left" src="/assets/hugoball.png">
    <p>
    My name is Brian Frost, and I'm a third-year electrical engineering PHD candidate at Columbia University. I am under dual advisement by Christine Hendon and Elizabeth Olson, working mostly at CUIMC's Fowler Lab.
	</p>
    <p>
	My research focuses on applications of spectral domain optical coherence tomography (SD-OCT) to the study of cochlear mechanics. In particular, I am interested in reconstructing the three-dimensional micromechanical motions with in the Organ of Corti complex using a collection of spatially resolved one-dimensional OCT measurements.
    </p>
	<p>
	Outside of work, I enjoy cooking, reading about inter-war art history, listening to noise rock and hip hop music, and collecting/playing vintage Nintendo games.
	</p>
    <div style="clear: both"></div>      
  </div>
</div>
~~~


<!-- \tableofcontents --><!-- you can use \toc as well -->
## publications

* **2022 - Using volumetric optical coherence tomography to achieve spatially resolved organ of Corti vibration measurements[^JASA2022]**

~~~
<div class="row">
  <div class="container">
    <img class="left" src="/assets/jasacover.jpg" width="300px" height="400px">
	<p>
		This paper outlines a method for achieving a mapping between the optical coordinates imposed by an OCT system and the anatomical coordinates with which the cochlea is naturally endowed. It appears on the cover of the February 2022 issue of the Journal of the Acoustical Society of America. The manuscript and figures are available as PDFs on <a href = "https://github.com/Brian-Frost-LaPlante/OCT-for-spatially-resolved-OCC-vibrometry">my github</a>, alongside the MATLAB code for the orientation programs applied in the study.
	</p>
    <div style="clear: both"></div>      
  </div>
</div>
~~~

* **2021 - Model of cochlear microphonic explores the tuning and magnitude of hair cell transduction current[^BPJ2021]** 

~~~
<div class="row">
  <div class="container">
    <img class="up" src="/assets/CMFEM.png" style="width:auto;height:265px;">
	<p>
		This paper outlines a method for achieving a mapping between the optical coordinates imposed by an OCT system and the anatomical coordinates with which the cochlea is naturally endowed. It appears on the cover of the February 2022 issue of the Journal of the Acoustical Society of America. The manuscript and figures are available as PDFs on <a href = "https://github.com/Brian-Frost-LaPlante/OCT-for-spatially-resolved-OCC-vibrometry">my github</a>, alongside the MATLAB code for the orientation programs applied in the study.
	</p>
    <div style="clear: both"></div>      
  </div>
</div>
~~~

<!--
## blog posts
-->

## References
[^JASA2022]:  [Frost, Strimbu and Olson (2022)](https://asa.scitation.org/doi/abs/10.1121/10.0009576).
[^BPJ2021]:  [Frost and Olson (2021)](https://pubmed.ncbi.nlm.nih.gov/34384762/).

<!-- 
## Blog Posts

This section is meant as a refresher if you're new to Franklin.
Have a look at both how the website renders and the corresponding markdown (`index.md`).
Modify at will to get a feeling for how things work!

Ps: if you want to modify the header or footer or the general look of the website, adjust the files in
* `src/_css/` and
* `src/_html_parts/`.

## The base with Markdown

The [standard markdown syntax](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) can be used such as titles using `#`, lists:

* element with **bold**
* element with _emph_

or code-blocks `inline` or with highlighting (note the `@def hascode = true` in the source to allow [highlight.js](https://highlightjs.org/) to do its job):

```julia
abstract type Point end
struct PointR2{T<:Real} <: Point
    x::T
    y::T
end
struct PointR3{T<:Real} <: Point
    x::T
    y::T
    z::T
end
function len(p::T) where T<:Point
  sqrt(sum(getfield(p, η)^2 for η ∈ fieldnames(T)))
end
```

You can also quote stuff

> You must have chaos within you to ...

or have tables:

Note that you may have to do a bit of CSS-styling to get these elements to look the way you want them (the same holds for the whole page in fact).

### Symbols and html entities

If you want a dollar sign you have to escape it like so: \$, you can also use html entities like so: &rarr; or &pi; or, if you're using Juno for instance, you can use `\pi[TAB]` to insert the symbol as is: π (it will be converted to a html entity).[^1]

If you want to show a backslash, just use it like so: \ ; if you want to force a line break, use a ` \\ ` like \\ so (this is on a new line).[^blah]

If you want to show a backtick, escape it like so: \` and if you want to show a tick in inline code use double backticks like ``so ` ...``.

Footnotes are nice too:

[^1]: this is the text for the first footnote, you can style all this looking at `.fndef` elements; note that the whole footnote definition is _expected to be on the same line_.
[^blah]: and this is a longer footnote with some blah from veggie ipsum: turnip greens yarrow ricebean rutabaga endive cauliflower sea lettuce kohlrabi amaranth water spinach avocado daikon napa cabbage asparagus winter purslane kale. Celery potato scallion desert raisin horseradish spinach carrot soko.

## Basic Franklin extensions

### Divs

It is sometimes useful to have a short way to make a part of the page belong to a div so that it can be styled separately.
You can do this easily with Franklin by using `@@divname ... @@`.
For instance, you could want a blue background behind some text.

@@colbox-blue
Here we go! (this is styled in the css sheet with name "colbox-blue").
@@

Since it's just a `<div>` block, you can put this construction wherever you like and locally style your text.

### LaTeX and Maths

Essentially three things are imitated from LaTeX

1. you can introduce definitions using `\newcommand`
1. you can use hyper-references with `\eqref`, `\cite`, ...
1. you can show nice maths (via KaTeX)

The definitions can be introduced in the page or in the `config.md` (in which case they're available everywhere as opposed to just in that page).
For instance, the commands `\scal` and `\R` are defined in the config file (see `src/config.md`) and can directly be used whereas the command `\E` is defined below (and therefore only available on this page):

\newcommand{\E}[1]{\mathbb E\left[#1\right]}

Now we can write something like

$$  \varphi(\E{X}) \le \E{\varphi(X)}. \label{equation blah} $$

since we've given it the label `\label{equation blah}`, we can refer it like so: \eqref{equation blah} which can be convenient for pages that are math-heavy.

In a similar vein you can cite references that would be at the bottom of the page: \citep{noether15, bezanson17}.

**Note**: the LaTeX commands you define can also incorporate standard markdown (though not in a math environment) so for instance let's define a silly `\bolditalic` command.

\newcommand{\bolditalic}[1]{_**!#1**_} 

and use it \bolditalic{here for example}.

Here's another quick one, a command to change the color:

\newcommand{\col}[2]{~~~<span style="color:~~~#1~~~">~~~!#2~~~</span>~~~}

This is \col{blue}{in blue} or \col{#bf37bc}{in #bf37bc}.

### A quick note on whitespaces

For most commands you will use `#k` to refer to the $k$-th argument as in LaTeX.
In order to reduce headaches, this forcibly introduces a whitespace on the left of whatever is inserted which, usually, changes nothing visible (e.g. in a math settings).
However there _may be_ situations where you do not want this to happen and you know that the insertion will not clash with anything else.
In that case, you should simply use `!#k` which will not introduce that whitespace.
It's probably easier to see this in action:

\newcommand{\pathwith}[1]{`/usr/local/bin/#1`}
\newcommand{\pathwithout}[1]{`/usr/local/bin/!#1`}

* with: \pathwith{script.jl}, there's a whitespace you don't want 🚫
* without: \pathwithout{script.jl} here there isn't ✅

### Raw HTML

You can include raw HTML by just surrounding a block with `~~~`.
Not much more to add.
This may be useful for local custom layouts like having a photo next to a text in a specific way.


**Note 1**: again, entire such blocks can be made into latex-like commands via `\newcommand{\mynewblock}[1]{...}`.

**Note 2**: whatever is in a raw HTML block is *not* further processed (so you can't have LaTeX in there for instance). A partial way around this is to use `@@...` blocks which *will* be recursively parsed. The following code gives the same result as above with the small difference that there is LaTeX being processed in the inner div.

@@row
@@container
@@left ![](/assets/rndimg.jpg) @@
@@
Marine iguanas are **truly splendid** creatures. They're not found in equations like $\exp(-i\pi)+1$. But they're still quite cool.
~~~
<div style="clear: both"></div>
~~~
@@

## Pages and structure

Here are a few empty pages connecting to the menu links to show where files can go and the resulting paths. (It's probably best if you look at the source folder for this).

* [menu 1](/menu1/)
* [menu 2](/menu2/)
* [menu 3](/menu3/)

## References (not really)

* \biblabel{noether15}{Noether (1915)} **Noether**,  Körper und Systeme rationaler Funktionen, 1915.
* \biblabel{bezanson17}{Bezanson et al. (2017)} **Bezanson**, **Edelman**, **Karpinski** and **Shah**, [Julia: a fresh approach to numerical computing](https://julialang.org/research/julia-fresh-approach-BEKS.pdf), SIAM review 2017.

## Header and Footer

As you can see here at the bottom of the page, there is a footer which you may want on all pages but for instance you may want the date of last modification to be displayed.
In a fashion heavily inspired by [Hugo](https://gohugo.io), you can write things like

```html
Last modified: {{ fill fd_mtime }}.
```

(cf. `src/_html_parts/page_foot.html`) which will then replace these braces with the content of a dictionary of variables at the key `fd_mtime`.
This dictionary of variables is accessed locally by pages through `@def varname = value` and globally through the `config.md` page via the same syntax.

There's a few other such functions of the form `{{fname p₁ p₂}}` as well as support for conditional blocks. If you wander through the `src/_html_parts/` folder and its content, you should be able to see those in action.
-->


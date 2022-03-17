@def title = "brian l frost" 
@def date = Date(2022, 03, 10)

## about me
@@row
@@container
~~~
<img class="left" style ="width:35%;" src="/assets/hugoball.png">
~~~
My name is Brian Frost, and I'm a third-year electrical engineering PHD candidate at Columbia University. I am under dual advisement by Christine Hendon and Elizabeth Olson, working mostly at CUIMC's Fowler Lab. I received my BE in electrical engineering from The Cooper Union for the Advancement of Science and Art, and my MS in electrical engineering from Columbia university.

My research focuses on applications of spectral domain optical coherence tomography (OCT) to the study of cochlear mechanics. In particular, I am interested in reconstructing the three-dimensional micromechanical motions with in the Organ of Corti complex using a collection of spatially resolved one-dimensional OCT measurements. I can be reached at b.frost@columbia.edu

Outside of work, I enjoy cooking, reading about inter-war art history, listening to noise rock and hip hop music, and collecting/playing vintage Nintendo games.
@@
@@

## publications
 **2022 - Using volumetric optical coherence tomography to achieve spatially resolved organ of Corti vibration measurements[^JASA2022]**
@@row
@@container
~~~
<img class="left" src="/assets/jasacover.jpg" style="width:35%;">
~~~
This paper outlines a method for achieving a mapping between the optical coordinates imposed by an OCT system and the anatomical coordinates with which the cochlea is naturally endowed. We show that this method can be used to account for tonotopic cross-sectional differences between measured structures in single OCT measurements. We use our program to correct for this displacement, and show that it significantly changes the character of the relative phase responses of measured structures. It appears on the cover of the February 2022 issue of the Journal of the Acoustical Society of America. The manuscript and figures are available as PDFs on [my github](https://github.com/Brian-Frost-LaPlante/OCT-for-spatially-resolved-OCC-vibrometry), alongside the MATLAB code for the orientation programs applied in the study.
@@
@@

@@row
@@container
~~~
<p>
<br>
</p>
~~~
@@
@@

 **2021 - Model of cochlear microphonic explores the tuning and magnitude of hair cell transduction current[^BPJ2021]** 
@@row
@@container
~~~
<img class="up" src="/assets/CMFEM.png" style="width:100%;">
~~~
This paper presents a finite element model of the voltage in the Scala Tympani of the sensitive gerbil cochlea, in response to the current generated by outer hair cells transduction. This voltage, often called the cochlear microphonic, is a complicated summation of many current source contributions along the length of the cochlea, weighting local contributions more heavily. We find that our model can replicate cochlear microphonics similar in shape and magnitude to those measured experimentally so long as a) the transducer current is more sharply tuned than basilar membrane motion, and b) the magnitude of the transducer current is about four times larger *in vivo* than what has been measured *ex vivo*. We also show that we can match experimental responses at high frequencies by damaging the modeled cochlea's base, consistent with the basal damage seen via displacement data in many gerbil preparations. This work was published in Biophysical Journal in 2021. The manuscript and figures are available as PDFs on [my github](https://github.com/Brian-Frost-LaPlante/FEM-of-Cochlear-Microphonic).
@@
@@
<!--
## blog posts
-->

## References
[^JASA2022]:  [Frost, Strimbu and Olson (2022)](https://asa.scitation.org/doi/abs/10.1121/10.0009576).
[^BPJ2021]:  [Frost and Olson (2021)](https://pubmed.ncbi.nlm.nih.gov/34384762/).

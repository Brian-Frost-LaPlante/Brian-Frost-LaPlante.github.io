@def title = "brian l frost" 
@def date = Date(2022, 03, 10)

## about me
@@row
@@container
~~~
<img class="left" style ="width:35%;" src="/assets/hugoball.png">
~~~
My name is Brian Frost, and I'm an electrical engineering PHD candidate at Columbia University. I am under dual advisement by Christine Hendon and Elizabeth Olson, working mostly at CUIMC's Fowler Lab. I received my BEng in electrical engineering from The Cooper Union for the Advancement of Science and Art, and my MS in electrical engineering from Columbia university.

My research focuses on applications of spectral domain optical coherence tomography (OCT) to the study of cochlear mechanics. In particular, I am interested in reconstructing the three-dimensional micromechanical motions with in the Organ of Corti complex using a collection of spatially resolved one-dimensional OCT measurements. I can be reached at b.frost@columbia.edu

Outside of work, I enjoy cooking, reading about history, and collecting/playing vintage Nintendo games. I also operate a [YouTube channel](https://www.youtube.com/channel/UCLzaBAVxjdGUWS1oW_IW29Q) consisting of programming and hardware projects involving the Pokemon series.
@@
@@

## publications

 **2023 - Compressed sensing on displacement signals measured with optical coherence tomography[^CSVi]**
@@row
@@container
~~~
<img class="left" src="/assets/csvi.jpg" style="width:45%;">
~~~
This paper provides a method for compressed sensing vibrometry (CSVi) on OCT-measured displacement maps. We use a sparsity-promoting convex optimization technique based on total generalized variation (TGV) with uniform subsampling. With this method, we are able to reconstruct densely sampled displacement maps of the gerbil organ of Corti complex using only 10\% of samples with less than 5\% normalized mean square error. We show that this method beats out five other tested methods, and that it generalizes across stimulus frequencies, sound pressure levels and beam axis orientations relative to the sample anatomy. This work was published in Biomedical Optics Express in October, 2023.

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



 **2023 - A high-efficiency model indicating the role of inhibition in the resilience of neuronal networks to damage resulting from traumatic injury[^compneuro]**
@@row
@@container
~~~
<img class="left" src="/assets/compneuro.jpg" style="width:45%;">
~~~
This paper explores a model for focal axonal swelling, a common form of damage resulting from traumatic brain injury or neurodegenerative disorders. A common model for the damage is a Hodgkin-Huxley neuron with varying width, which manifests as a system of partial differential equations whose solution is computationally expensive. We have developed a method that rapidly predicts the dynamics when the input and output of the system is interpreted as a spike train. This allows for network-level simulations. In small feedforward networks, we show that pre-synaptic inhibition appears to reduce the impact of damage on the network's frequency discriminating abilities. This work was published in the Journal of Computational Neuroscience in August, 2023.

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


 **2023 - Reconstruction of transverse-longitudinal vibrations in the organ of Corti complex via optical coherence tomography[^JASA2023]**
@@row
@@container
~~~
<img class="left" src="/assets/jasa2023.jpg" style="width:45%;">
~~~
This paper provides a method for reconstructing 2- and 3-D displacement maps in the Organ of Corti complex. Instead of using advanced hardware or limiting volume processing techniques, the method relies on the physiological properties of the cochlea. In particular, it uses the phase of the traveling wave along the basilar membrane to register positions between different viewing angles. We present one data set in which we were able to reconstruct transverse and longitudinal components of the displacement response at the outer hair cell-Deiters cell junction in the gerbil cochlea. This work was published in the Journal of the Acoustical Society of America in February, 2023.
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
[^CSVi]: [Frost, Janjušević, Strimbu and Hendon (2023)](https://opg.optica.org/boe/fulltext.cfm?uri=boe-14-11-5539&id=540503)
[^compneuro]: [Frost and Mintchev (2023)](https://link.springer.com/article/10.1007/s10827-023-00860-0)
[^JASA2023]:  [Frost, Strimbu and Olson (2023)](https://pubs.aip.org/asa/jasa/article-abstract/153/2/1347/2866948/Reconstruction-of-transverse-longitudinal?redirectedFrom=fulltext)
[^JASA2022]:  [Frost, Strimbu and Olson (2022)](https://asa.scitation.org/doi/abs/10.1121/10.0009576)
[^BPJ2021]:  [Frost and Olson (2021)](https://pubmed.ncbi.nlm.nih.gov/34384762/)


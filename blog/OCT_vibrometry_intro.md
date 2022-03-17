+++
title = "Introduction to OCT Vibrometry"
date = Date(2022, 03, 15)
hascode = false
rss = "octvib"
tags = ["research"]
hasmath = true
mintoclevel=2
maxtoclevel=2
descr = """
@@row
@@container
~~~
<img class="left" style="width:30%;" src="/assets/telesto.jpg">
~~~
This is the first of a series of blog posts on the use of spectral domain optical coherence tomography (OCT) for measuring three-dimensional micromechanical motions in the organ of Corti complex (OCC), the mammalian hearing organ. In this first post, I will be covering the theory behind OCT imaging and vibrometry, and discussing why this modality is so well-suited for the study of cochlear micromechanics. Image: Thorlabs Telesto III SD-OCT system.
@@
@@

"""
+++

# {{title}}
@@row
@@container
~~~
<img class="left" style="width:30%;" src="/assets/telesto.jpg">
~~~
This is the first of a series of blog posts on the use of spectral domain optical coherence tomography (OCT) for measuring three-dimensional micromechanical motions in the organ of Corti complex (OCC), the mammalian hearing organ. In this first post, I will be covering the theory behind OCT imaging and vibrometry, and discussing why this modality is so well-suited for the study of cochlear micromechanics. Image: Thorlabs Telesto III SD-OCT system.
@@
@@

## The capabilities of OCT

OCT is a powerful modality for imaging at a depth with a relatively long working distance and fine resolution. It fills the gap between ultrasound, famously having poor resolution but capable of imaging quite deep into tissues, and confocal microscopy which has incredible resolution but short depth field of view. Field of view and resolution are a tradeoff, with low-wavelength OCT systems being able to achieve ~1 $\mu$m resolution but with only ~300 $\mu$m depth of focus. On the other hand, systems at higher wavelength can achieve a depth field of view of ~3 mm, at the cost of increasing the resolution to ~8 $\mu$m. Through scanning the beam of the system along two axes, OCT can be used to generate 3-D volumetric images. The lateral resolution is determined, mostly, by the usual diffraction limit.

While volumetric imaging is the most common application of OCT, it also sees niche use as an at-depth vibrometer. Through a process known as spectral domain phase microscopy (SDPM), sub-pixel motions of structures can be measured with angstrom-scale resolution. This can be performed at any point along the depth of the scan, meaning the motions of multiple imaged structures can be measured at once.

The OCT system used in the Fowler Lab at Columbia University, the Telesto 311C shown in the image above,  has a center wavelength of about 1350 nm, yielding an axial resolution of ~8 $\mu$m and a depth field of view of about 3 mm. Its lateral resolution is also ~8 $\mu$m and it is capable of angstrom-scale vibrometry through SDPM. How does these scales compare to structures and vibrations in the cochlea? How does hearing work anyway? I'm glad you asked.

## The incredible ear

Sound is a pressure wave, wherein molecules in a medium like water and air compress and expand in some modal pattern in accordance to forces produced by vocal chords, pianos, trucks or birds. In mammals, these sounds are funneled through the outer ear towards the eardrum, which vibrates in response to the forces incurred upon it by these pressure waves. These vibrations are passed on through three bones in the middle ear, which have mechanical properties that attenuate certain frequency components of sound. The last of these bones, the stapes, pushes against the oval window of the cochlea, a fluid filled snail-shaped structure, wherein the mechanical vibrations are turned back into pressure waves, this time in water.

This is where the magic happens. The basilar membrane (BM) is a plate-like structure which follows the cochlea's spiral. The fluid pressure wave incurs a mechanical vibration at the BM, whose mechanical properties control the form of this "traveling wave". From the base (nearest the oval window) to the apex (the tip of the snail shell), the stiffness of the BM decreases. As a result, the position at which certain frequencies cause higher vibrations varies along the length of the cochlea, with lower frequencies peaking at the apex and higher frequencies peaking at the base. This lends the BM its frequency analyzer characteristics.

Atop the BM lies the organ of Corti, which contains many structural and functional cells. The inner and outer hair cells (IHCs, OHCs) are the most interesting of these. They get their name from the tiny hair-like stereocilia which lie upon their apex. As the organ of Corti vibrates with the BM, these stereocilia push against the gell-like tectorial membrane (TM), causing them to tilt back and forth. Together, the BM, organ of Corti and TM are reffered to as the organ of Corti complex (OCC).

The stereocilia contain mechanically gated ion channels, which open and close as they push against the TM. This leads to an oscillatory current, which varies along the length of the cochlea in the same frequency analyzer fashion. The IHC current leads to neural transmission through the auditory nerve, which eventually leads to the brain where it is processed to provide us the sense that we have heard something, broken down into its frequencies to be interpreted as speech, music, noise, birds.

The OHC walls contain an electromotile protein called prestin. As the voltage within the OHC oscillates, prestin causes the OHC to expand and compress. This active process amplifies motion of the OCC, and is in part responsible for our incredible ability to sense sound at lower sound pressure levels (SPLs). The absence of OHC function, and thereby this cochlear amplification, is a common cause of sensorineural hearing loss -- the most common kind of hearing loss.

Our physiology lesson is out of the way... for now. So back to our question -- how does this anatomy and physiology compare to OCT resolutions? In the base of the gerbil cochlea where our data are taken, the OHCs are 10 $\mu$m wide and 40 $\mu$m tall. This means that our system, with 8 $\mu$m resolution, cannot really make out the difference between individual outer hair cells well, but can certainly isolate them from other nearby structures. The motions of the OHCs and BM measured in our experimenta range from 3 angstroms at the threshold of hearing (~0 dB SPL) to about 20 nm at 80 dB SPL. At lower SPL, these measurements usually lie a within the noise level, but we can make high-quality measurements at SPLs above ~20 dB. For reference, rustling leaves make noise at about 20 dB SPL, normal conversation occurs at about 60 dB SPL and rock concerts expose you to noise around 120 dB SPL.

Hopefully you are now convinced that OCT is well-fit for cochlear vibrometry research, but I would have nothing to write if these measurements were perfect. In fact, a few problems plague OCT measurements of inner ear vibrations, but before I expound upon them I should briefly describe how OCT works.

## OCT imaging

The OCT architecture is that of a Michaelson-Morley interferometer. Light from a wideband light source is split into two -- a reference beam which travels some distance $z_r$ to a mirror and is reflected back entirely unobstructed, and a sample beam which travels into the sample to be imaged, being reflected back at every reflective surface within the sample. The two beams arrive back at the beam splitter, superpose, and then pass through a diffraction grating. The intensity $I(K)$ is recorded as a function of the wavenumber $k=2\pi /\lambda$ at the output of the diffraction grating.

Writing this mathematically, suppose $S(k)$ is the intensity spectrum of the wideband light source, $E_r$ is the electric field from the reference path, and $E_s$ is the electric field from the sample path. Assume half of the power has gone to the reference, and half has gone to the sample so that each beam begins with field amplitude $\sqrt{S(k)/2}$. Arriving at the beam splitter post-reflection, the the reference beam will have travelled $2z_r$, and will have had its amplitude altered by a factor of the reference mirror's reflectivity $r_r$. We can thereby write

\begin{equation}\label{refbeam}
E_r(k) = r_r\sqrt{\frac{S(k)}{2}}e^{j2kz_r}.
\end{equation}

Note that the field is also technically dependent on time, but we have left this out for now. this manifests as an $e^{-j\omega t}$ which can be pulled out of each wave term. Moreover, technically the $k$ term should be multiplied by the index of refraction of the medium. We will leave that out for now, but remember this for later.

How about the sample beam? This beam travels through the sample, reflecting at many surfaces along the way. Say that $N$ reflectors with reflectivities $r_n$ lie distance $z_n$ from the beam splitter, for $n$ from 1 to $N$. Then the returning sample beam is the sum of what has been reflected from each surface,


\begin{eqnarray}
E_s(k) &=& \sqrt{\frac{S(k)}{2}}\sum_{n=1}^N r_n e^{j2kz_n}\\
&=& \sqrt{\frac{S(k)}{2}}\sum_{n=1}^N r_n \delta(z-z_n) e^{j2kz}\\
&=& \sqrt{\frac{S(k)}{2}} r(z) * e^{j2kz}
\end{eqnarray}

where $*$ denotes convolution and $r(z)$ is the sample reflectivity as a function of depth into the sample.

Using these formulae for the sample and reference beams, we can right the OCT signal, $I(k)$ as the intensity spectrum of the superposition of these waves. This is a time average of the square amplitude of the sum of the waves. I will skip a few steps and exclude constant factors:

\begin{eqnarray}
I(k) &\propto& <|E_r + E_s|^2> \\ 
 &\propto& S(k) (r_r^2 + r_1^2 + \ldots + r_n^2) + \\
 && S(k) \sum_{n=1}^N r_rr_n \cos(2k(z_r - z_n)) + \\
 && S(k) \sum_{n\neq m} r_mr_n \cos(2k(z_m - z_n)). 
\end{eqnarray}

To get here, I had to use the complex cosine definition. We refer to the three terms here as (1) the DC term, which is simply proportional to the light source spectrum $S(k)$, (2) the cross-correlation term which encodes phase differences between the reference and the light returning from each reflector, and (3) the autocorrelation term which encodes the phase differenes between light returning from each pair of reflectors. We make the assumption that $r_r \approx 1$, and is much bigger than the sample reflectances, so that the autocorrelation terms is approximately zero.

We often refer to the spectrum $S(k)$ as the background, which serves both as the DC term and as a multiplier for the cross-correlation term. The OCT scan should give us information about the depth profile of the reflectivity, which is contained entirely in the cross-correlation term. It would be good to get rid of the DC term, then, as well as to get rid of the multiplying $S(k)$ term.

In practice, it is easy to measure the background -- if we turn off the sample beam (which can be done in a number of mechanical, electrical or optical ways), the light arriving at the detector is proportional to $S(k)$. We measure this before every recording. We write

\begin{equation}
I_0(k) = \frac{I(k) - S(k)}{S(k)} \approx \sum_{n=1}^N r_n \cos(2k(z_r - z_n))
\end{equation}

Taking the Fourier transform, we have
\begin{equation}
i_0(z) = \sum_{n=1}^Nr_n [\delta(z+2(z_r-z_n)) + \delta(z-2(z_r-_n))],
\end{equation}
i.e. each reflective point in depth is marked by an indicator, weighted by its reflectivity! This is called an A-Scan, or axial scan. By taking multiple A-Scans along a line segnment, one can form an image or B-Scan using the A-Scans at each position as a column in the image. Of course, one can then take parallel B-Scans to form a C-Scan, or volume scan.

Let me give a brief summary of what we just walked through: the OCT scan is formed by observing the intensity of two interfering beams, whose phase differences are determined by the distance into the sample from which the sample beam reflected. This manifests as a sinusoidal term in $k$ for each reflector, which fourier transforms to an indicator in $z$.

I should note that the background compensation process is a bit more detailed than this, and has significant importance in the development of OCT probe technology. If you are interested, check out [these reports](https://github.com/Brian-Frost-LaPlante/LabReports/tree/main/ProbeReports).

## OCT vibrometry

For cochlear mechanics studies, the main application of OCT as an imaging modality is to situate ourselves within the cochlea so that we know where to take vibration measurements. It is not immediately clear from the imaging theory above how the system would ever be able to measure vibrations. To see this, let's imagine the special case where there is only one reflector at $z_0$ with reflectance $r_0$.

The OCT signal is quantized, so $z_0$ lies within one pixel. Let's call the position of the pixel it lies inside $z_p$, so that $z_0 = z_p + d_0$ and $d_0$ is less than the pixel size. Now let's add in vibrations: say that the object at this point is moving in the $z$ direction like $d(t)$, where the magnitude of motion is considerably smaller than the pixel size. Then the optical path length between the reference and sample beam is $2n(z_p + d_0 +d(t))-2z_r$, where $n$ is the index of refraction of the sample. In our experiments, this is usually that of water, $n\approx 1.33$.

For the time-dependent term, we make an approximation: that $k\approx k_0$, the center wavelength of the system. With the background subtracted and divided out, this contributes to the remaining cross-correlation term as

\begin{equation}
I_0(k) \approx r_0 \cos(2kn(z_p+d_0-z_n/r) + 2nk_0d(t)).
\end{equation}

The Fourier transform, looking at the pixel corresponding to $z_p$, gives
\begin{equation}
i_0(z_p) = \frac{r_0}{2} e^{j2k_0nd(t)},
\end{equation}
a complex number with argument proportional to the subpixel motion! That is, we can measure the sub-pixel motion by taking A-Scans over time at one position (an M-Scan), and considering the pixel-wise phase as a function of time: 

\begin{equation}
d(t) = \frac{\text{Arg}(i_0(z_p))}{2nk_0}.
\end{equation}

This process, known as spectral domain phase microscopy, allows us to measure OCC vibrations in the angstrom range. Moreover, an M-Scan is a series of A-Scans taken over time, which record intensity at every pixel along a line into the sample. That is, we can record the vibrations at every pixel within an A-Scan using this method, meaning we could measure, for example, BM and OHC at the same time.

## What's wrong, Brian?

This is all incredible, of course -- we have a system that allows us to orient ourselves within the cochlea via volumetric imaging, and also allows us to measure with sub-nanometer resolution at all points along a line into a sample. So what's wrong?

My research is currently focused on two major problems with current OCT data acquisition in cochlear mechanics, each to be covered in more detail in future blog posts, but I will lay them out here for motivation.

A-Scan measurement axes are not always perpendicular to the surface of the BM -- in fact, they vary significantly in angle between preparations, and thereby between research groups. Some groups, such as ours, tend to take measurements at angles of almost 60 degrees with the BM normal, while others measure nearer to perpendicular.

Consider the common case where BM and OHC are measured within a single A-Scan. What does "same A-Scan" mean from an anatomical point of view? If the viewing angle is perfectly normal to the BM, these structures lie in the same longitudinal cross-section. However, if the angle is large, the OHCs in this scan may lie apical of the measured BM location -- we find by almost 50 $\mu$m in many cases! This could cause significant differences, especially if we think about the character of the traveling wave described earlier. A more apical position means a different best frequency, and thereby a characteristically different frequency response.

The second ambiguity comes from the fact that SDPM measures only motion along the optical $z$ axis. This axis has no physiological significance inherently, so this means that we are really measuring projection of a three-dimensional motion onto a contrived single-dimensional axis. With no knowledge of what anatomical components this projection weights most heavily, we cannot say much about what the measurements mean. Moreover, a single one-dimensional measurement can be used only to gain limited insight into a three-dimensional motion, especially if the angle is not something inherently physiologically relevant. 

My goal, along with many other researchers in the field, is to design a data acquisition scheme which may account for both of these issues. In my next post in this series, I will be describing my proposed solution to the first of these problems, along with some published data on the topic. See you in the future.

Thanks for reading! Feel free to email any questions to me at b.frost@columbia.edu

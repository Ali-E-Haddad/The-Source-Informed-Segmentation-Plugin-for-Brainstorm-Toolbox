**The Source-Informed Segmentation Plugin for Brainstorm Toolbox**

1. **About the Plugin:**

This plugin employs the _Source-Informed Segmentation Algorithm_ [1] in the temporal segmentation of EEG files within the Brainstorm toolbox [2]. The plugin segments the EEG data in the files passed to it and returns a new set of files, with the processed EEG data marked by the detected segment boundaries as extended events, which can be found in the (.Event) field of each processed file. Furthermore, the parameters and secondary outcomes of the _Source-Informed Segmentation Algorithm_ and other options used by the plugin are saved to the (.SISegment) field added to each of these processed files (see section 6). The processed files are added back to the Brainstorm workspace. Additionally, the plugin collects various statistics which summarize the performed segmentation processes. The statistics are displayed after the completion of all segmentation processes, and can optionally be saved to a user selected file.

The plugin can be applied either to one set of files, to be processed and statistically summarized together, or to two sets of files, to be equivalently processed then compared using the same statistical measures.

For citation, see [1] below.

1. **Installing the Plugin:**

Copy the two files:

&quot;process\_SISegmentationMD.m&quot; and &quot;process\_SISegmentationMD2.m&quot;,

intended to perform _Source-Informed Segmentation_ under &quot;Process1&quot; and &quot;Process2&quot; tabs, respectively, to the Brainstorm user process folder:

&quot;$HOME/.brainstorm/process&quot;.

1. **Running the Plugin:**

- Run the &quot;brainstorm&quot; toolbox from MATLAB&#39;s command window.
- Select the EEG files to be processed from the &quot;Functional data&quot; pane ![](RackMultipart20201204-4-v1xhjo_html_6e689a2fe955218d.png).

![](RackMultipart20201204-4-v1xhjo_html_6e689a2fe955218d.png)

- Drag the selected files then drop them in the &quot;Files to process: Data [#]&quot; pane of the &quot;Process1&quot; tab, for them to be processed together,

![](RackMultipart20201204-4-v1xhjo_html_a043604dc11f2465.png)

or either the &quot;Files A: Data [#]&quot; or &quot;Files B: Data [#]&quot; pane of the &quot;Process2&quot; tab, for them to be compared to the files in the other pane of the latter tab (two sets of files will be needed for this comparison).

![](RackMultipart20201204-4-v1xhjo_html_2c9572503e7199b7.png)

Dropping files adds them to the files already existing in the given pane. The number of total files eligible for processing in each pane (denoted as # above) should appear inside the square brackets.

- Press the &quot;RUN&quot; button ![](RackMultipart20201204-4-v1xhjo_html_a043604dc11f2465.png) near the lower left corner of the Brainstorm toolbox window to bring the &quot;Pipeline editor&quot;.

![](RackMultipart20201204-4-v1xhjo_html_6f91392813aff5d2.png)

- Press the &quot;Add process&quot; button ![](RackMultipart20201204-4-v1xhjo_html_6f91392813aff5d2.png) to bring the drop-down list of available processes.

![](RackMultipart20201204-4-v1xhjo_html_dc90b32427fa6c7f.png)

- From &quot;Temporal Segmentation&quot; choose &quot;Source-Informed Segmentation&quot; to bring the &quot;Process options&quot; window. Maximize the window if the &quot;Cancel&quot; and &quot;Run&quot; buttons do not appear in the lower right corner.

![](RackMultipart20201204-4-v1xhjo_html_d148b3b80f472122.png)

- Enter the values and/or make the choices relevant to the intended _Source-Informed Segmentation_ process. Note that the window will remember the last values and choices. To reset these to their corresponding defaults, in the &quot;Pipeline editor&quot; window press the &quot;Load/save processing pipeline&quot; button ![](RackMultipart20201204-4-v1xhjo_html_6f91392813aff5d2.png), then from the drop-down list choose &quot;Reset options&quot;.
- After entering/making all the relevant values/choices, press the &quot;Run&quot; button to start the _Source-Informed Segmentation_ process.

1. **Plugin Parameters and Options:**

1. Window Parameters

These parameters define the widths of the corresponding windows (see section 5) used by the _Source-Informed Segmentation Algorithm_ [1]. They are passed in either [sample] or [ms] units, or, in the case of some of them, in the same unit used to pass some other window&#39;s width. The radio button below the input field of each window parameter specifies its unit.

- Initial Reference Window (): the initial width of the reference window, where .
- Decision Window (): the minimum number of consecutive possible boundaries needed for one of them to be considered a detected boundary, where .
- Sliding Window (): the width of the sliding window, where .
- Step (): the amount of each discrete expansion in the width of the reference window and the corresponding shift in the position of the sliding window, where .
- Overlap (): the width of the overlap between the reference and the sliding window, where .

1. Time Interval to Segment

Using these options, the interval to be cropped out of the EEG files towards processing can be defined, if cropping is needed. If one or both interval limits are undefined, the corresponding limits are assigned the beginning or the end of the individual EEG files.

- Start Time (): the starting point, in [s], of the cropping interval.
- End Time (): the ending point, in [s], of the cropping interval.
- On Encountering File(s) Incompatible with Time Interval to Segment: this option defines the action to take when one or more EEG files have time intervals that do not cover one or both limits of the cropping interval. The radio button can assume one of the following values:
  - Ignore Incompatibility: proceed with the part of the cropping interval that is covered by each EEG file.
  - Restrict Interval for Global Compatibility: redefine the cropping interval as the intersection of the intervals of all EEG files and the cropping interval to ensure compatibility across all files, if possible.
  - Skip Incompatible File(s): do not process incompatible files.
  - Abort: if any incompatible file is encountered, abort without processing any file, regardless of their possible compatibility.

1. Preprocessing

These options allow for various processes to be applied to the EEG data prior to attempting to detect segment boundaries.

- Domain of Analysis: select the domain within which the _Source-Informed Segmentation Algorithm_ [1] is to be applied. These domains are:
  - Time: with a functional connectivity measure equivalent to correlation.
  - Frequency: with a functional connectivity measure equivalent to the imaginary component of coherence, using an analytical Morlet wavelet-based filter-bank.
  - Phase: with a functional connectivity measure equivalent to phase-locking value (PLV), in terms of the analytical signal calculated using Hilbert transform.
- Frequency Band of Interest (): if specified, define the low and high limits in [Hz] of the band-pass filter applied to the EEG data prior to segmentation, with . When or , where is the sampling rate, a high-pass or low-pass filter, respectively, is applied, instead.
- Reference Space Average Removal: whether to remove the channel-wise average of the reference window before calculating the reference space (in the time domain) or not.

1. Segment Events

These options apply to the segment boundary events to be added to the individual EEG files to be processed.

- Segment Events Color (): the color of the added segment boundary events in RGB format, where .
- Clear Pre-Existing Events: whether to clear the events already saved in the individual EEG files to be processed or not.

1. Segmentation Statistics

These options apply to the statistics collected from the processed EEG files.

- Time Bins to Count Segment Boundary/Midpoint Recurrences: if specified as a vector or a scalar, it is used to define the edges or the number, respectively, of the time bins within which the average numbers of segment boundaries/midpoints are counted.
- Export Segmentation Statistics to File: if specified, a (.mat) file with the statistics collected from the processed EEG files is created and saved.

1. **About the Source-Informed Segmentation Algorithm:**

The _Source-Informed Segmentation Algorithm_ [1] detects the instants, in the EEG data, at which the functional state of the brain changes. To achieve that, the algorithm compares the EEG activity within two windows: the _reference window_, initially of width , and the _sliding window_, of constant width . The two windows have an _overlap_ of constant width . Each comparison may reveal either a _possible boundary_ or _not a boundary_.

![](RackMultipart20201204-4-v1xhjo_html_1a017067813e1157.gif)

As consecutive comparisons are made, the reference window grows in a _step_ of constant width , each time, pushing the sliding window by the same step to keep the overlap constant. A boundary is detected when at least , the width of the _decision window_, consecutive possible boundaries are found. The _detected boundary_ corresponds to the possible boundary with the maximum likelihood, as determined by the comparison.

![](RackMultipart20201204-4-v1xhjo_html_6a4396b149e9d7c4.gif)

1. **The Contents of the (.SISegment) Field of Processed EEG Files:**

This field saves the following parameters and secondary outcomes of the _Source-Informed Segmentation Algorithm_ [1] and other options used by the plugin when applied to an EEG file:

- : the width of the initial reference window.
- : the width of the decision window.
- : the width of the sliding window.
- : the step width.
- : the width of the overlap between the reference and sliding windows.
- unit: the unit of the window parameters.
- Domain: the domain of _Source-Informed Segmentation_.
- Band: the frequency band of interest (), if specified.
- AvRemove: the reference space average removal option.
- svals: (1 × no. segments) cell array with vectors carrying the set of significant singular values corresponding to each detected segment.
- svecs: (1 × no. segments) cell array with matrices carrying the set of significant left singular column vectors corresponding to each detected segment.
- erat: (1 × no. segments) vector with the ratios of energy captured by the sets of significant singular values corresponding to each detected segment.
- pval: (1 × no. segments) vector with the -vaues calculated at the detected segment boundaries, based on the Kolmogorov-Smirnov (K-S) test.
- avsegs: (no. of EEG channels × no. segments) matrix with the average EEG topography of each detected segment.
- stdsegs: (no. of EEG channels × no. segments) matrix with the channel-wise standard deviation of the EEG signal within each detected segment.
- label: the label of the corresponding segment boundary events.

1. **A Tutorial Example:**

Here, two sets of files, placed in &quot;Files A: Data [#]&quot; and &quot;Files B: Data [#]&quot; panes of the &quot;Process2&quot; tab, are processed, separately, using the _Source-Informed Segmentation_ plugin.

![](RackMultipart20201204-4-v1xhjo_html_dda1f43fac4596c6.png)

The window parameters used with the _Source-Informed Segmentation Algorithm_ [1] are:

- [sample], [sample], [same as], [sample], and [sample].

To process the interval 0 – 2 s from each EEG file, or whatever sub-interval of it a file covers, the following options are used with the plugin:

- , , and &quot;Ignore Incompatibility&quot;.

Furthermore, EEG data is to be processed in the &quot;Time&quot; domain, within the _δ_, _θ_, and _α_ bands. Thus, the Frequency Band of Interest is chosen as:

- .

For statistical summarization, segment boundaries/midpoints are counted within the:

- Time Bins: .

The statistics are then saved to a (.mat) file that is created and named using the browse button ![](RackMultipart20201204-4-v1xhjo_html_dc40998778b7d5fa.png).

![](RackMultipart20201204-4-v1xhjo_html_dc40998778b7d5fa.png)

After processing the EEG files in both panes, separately, the processed files appear in the &quot;Functional data&quot; pane, with their original names appended by &quot; | SIS&quot;.

![](RackMultipart20201204-4-v1xhjo_html_285afa8062cbe303.png)

Note that the segment boundary events of a given processed EEG file can be viewed using Brainstorm&#39;s own viewer, invoked by double-clicking the file, and own event display formats. Below, the segment boundary events are shown as labeled &quot;Dots&quot; in blue (), the color the plugin options dictated earlier. Brainstorm offers different EEG and event viewing modes that can be controlled through the list accessible by clicking the &quot;Display Configuration&quot; button ![](RackMultipart20201204-4-v1xhjo_html_f4e9d2cbca4416ce.png) near the lower right corner of the viewer window.

![](RackMultipart20201204-4-v1xhjo_html_f4e9d2cbca4416ce.png)

The plugin also summarizes the statistics collected from the _Source-Informed Segmented_ EEG files in each of the two sets &quot;Files A&quot; and &quot;Files B&quot;, using 8 plots that are grouped into two figure windows. In the case of &quot;Process2&quot;, each plot is used to compare the files in the two sets. In the non-comparative case of &quot;Process1&quot;, each plot corresponds to the entire set of EEG files that would be placed in the &quot;Files to process: Data [#]&quot; pane. The statistics used in the aforementioned plots can also be exported to the file that was specified by the corresponding plugin option. The files saved in the cases of &quot;Process1&quot; and &quot;Process2&quot; are the same, in terms of the structures they contain. The main difference constitutes in the fields of these structures that are intended for the main data entries, which, in the case of &quot;Process2&quot; consist of two sub-fields themselves: (.A) and (.B) for the corresponding file panels. Some structures also include additional test results, _e.g._, -values and Peasrson correlation coefficients, which give context-relevant comparisons between &quot;Files A&quot; and &quot;Files B&quot;, in the case of &quot;Process2&quot;.

The first figure window includes:

- Average No. of Segment Boundaries: the average number of segment boundaries, per EEG file (trial), occurring during each of the time bins. These bins are controlled by the corresponding plugin option entered earlier. The data in this plot is saved to the structure &quot;HistSegmentBoundaries&quot;.
- Segment Length vs. Beginning Boundary: a scatter plot of all segment lengths vs. their corresponding beginning boundaries, across all EEG files. The data in this plot can be calculated from the contents saved in the structure &quot;SegmentBoundaries&quot;. In the case of &quot;Process2&quot;, a bivariate K-S test is conducted to compare &quot;Files A&quot; to &quot;Files B&quot; in terms of segment length/boundary pairs. The -value of the test is shown in the plot, and is saved to the field &quot;HistSegmentBoundaries.BiKSpvalue&quot;.
- Average No. of Segment Midpoints: the average number of segment midpoints, per EEG file (trial), occurring during each of the time bins. These bins are controlled by the corresponding plugin option entered earlier. The data in this plot is saved to the structure &quot;HistSegmentMidPoints&quot;.
- Segment Length vs. Midpoint: a scatter plot of all segment lengths vs. their corresponding midpoints, across all EEG files. In the case of &quot;Process2&quot;, a bivariate K-S test is conducted to compare &quot;Files A&quot; to &quot;Files B&quot; in terms of segment length/midpoint pairs. The -value of the test is shown in the plot, and is saved to the field &quot;HistSegmentMidPoints.BiKSpvalue&quot;.

![](RackMultipart20201204-4-v1xhjo_html_58c813b78f64d271.png)

The second figure window includes:

- Average Length of Encompassing Segment: the average length of the segment, across all EEG files (trials), which contain a given time sample, calculated dynamically at each time sample. Also plotted, here, is one corresponding dynamically calculated standard deviation above and below the average curve. The overall mean (_µ_) and standard deviation (_σ_) of each curve is shown in the plot. In the case of &quot;Process2&quot;, Pearson correlation coefficient of the two curves is calculated and shown in the plot. The data in this plot is saved to the structure &quot;DynamicSegmentLength&quot;. Similarly, the dynamic average/standard deviation of the duration until the end of the encompassing segment, at a given time sample, is calculated and saved to the structure &quot;DynamicDurationtoSegEnd&quot;, without being plotted.
- PMF of Segment Lengths: the histogram, _i.e._, empirically estimated probability mass function (PMF), of all segment lengths throughout all EEG files (trials). The average (Av) and standard deviation (SD) of all segment lengths are shown in the plot. The histogram is also fitted to a Burr distribution with parameters , , and _α_, all shown in the plot. The goodness of fit is evaluated through a test and the -value of it is shown in the plot. The histogram, the probability density function (PDF) of the approximate Burr distribution, and the outcomes of the test are saved to the structure &quot;HistSegmentLengths&quot;. In the case of &quot;Process2&quot;, a K-S test is conducted to compare &quot;Files A&quot; to &quot;Files B&quot; in terms of the segment lengths. The -value of this test is shown in the plot. The segment lengths used in this plot and the -value of the K-S test are saved to the structure &quot;AllSegmentLengths&quot;.
- Maximum Segment Length vs. Beginning Boundary: a scatter plot of the maximum length of the segments in each EEG file (trial) vs. their corresponding beginning boundaries. The average (Av) and standard deviation (SD) of the maximum lengths, across all EEG files, are shown in the plot. The data in this plot is saved to the structure &quot;MaxSegmentLengths&quot;.
- Minimum Segment Length vs. Beginning Boundary: a scatter plot of the minimum length of the segments in each EEG file (trial) vs. their corresponding beginning boundaries. The average (Av) and standard deviation (SD) of the minimum lengths, across all EEG files, are shown in the plot. The data in this plot is saved to the structure &quot;MinSegmentLengths&quot;.

![](RackMultipart20201204-4-v1xhjo_html_28d1207af8b657aa.png)

**References:**

1. [Ali E. Haddad and Laleh Najafizadeh, &quot;Source-informed segmentation: A data-driven approach for the temporal segmentation of EEG,&quot; _IEEE Transactions on Biomedical Engineering_, vol. 66, no. 5, pp. 1429-1446, 2019.](https://ieeexplore.ieee.org/abstract/document/8481379)
2. [https://neuroimage.usc.edu/brainstorm/Introduction](https://neuroimage.usc.edu/brainstorm/Introduction)

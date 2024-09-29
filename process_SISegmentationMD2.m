function varargout = process_SISegmentationMD2(varargin) %#ok<STOUT>
% process_SISegmentationMD2 applies the source-informed segmentation algorithm [Ref]
% to the input EEG data in the time, frequency, or phase domain.

% @================================================================================
% The source-informed segmentation algorithm [Ref]:
%
%   The algorithm estimates the time intervals during which the EEG data correspond
% to stationary spatial distributions for the underlying active functional networks
% in the brain.
%
% [Ref] Ali E. Haddad and Laleh Najafizadeh, "Source-informed segmentation: A data-
%       driven approach for the temporal segmentation of EEG," IEEE Transactions on
%       Biomedical Engineering, vol. 66, no. 5, pp. 1429-1446, 2019.
%       https://ieeexplore.ieee.org/abstract/document/8481379
% ================================================================================@
%
% Author: Ali Haddad, September 2024.

eval(macro_method);
end


%% ===== GET DESCRIPTION =====
function sProcess = GetDescription() %#ok<DEFNU>
    % Description of the process
    sProcess.SubGroup    = 'Temporal Segmentation';
    sProcess.Comment     = 'Source-Informed Segmentation';
    sProcess.Category    = 'Custom';
    sProcess.Index       = 411;
    sProcess.Description = 'http://eceweb1.rutgers.edu/~laleh/softwareTools/Source-Informed%20Segmentation.pdf';
    sProcess.isSeparator = 0;
    % Definition of the input accepted by this process
    sProcess.InputTypes  = {'data'};
    sProcess.OutputTypes = {'data'};
    sProcess.nInputs     = 2;
    sProcess.nMinFiles   = 1;
    sProcess.processDim  = [];
    % Definition of the options
    % === Window Parameters
    sProcess.options.labelWin.Class     = 'Window';
    sProcess.options.labelWin.Comment   = '<U><B>Window Parameters</B></U>';
    sProcess.options.labelWin.Type      = 'label';
    % === Wr
    sProcess.options.Wr.Class           = 'Window';
    sProcess.options.Wr.Comment         = '<i>W<sub>r</sub></i>: Initial Reference Window (no default, suggested = 20 [sample]): ';
    sProcess.options.Wr.Type            = 'text';
    sProcess.options.Wr.Value           = '20';
    %
    sProcess.options.WrUnit.Class       = 'Window';
    sProcess.options.WrUnit.Comment     = {'[sample]','[ms]','<i>W<sub>r</sub></i> Unit: ';'sample','ms',''};
    sProcess.options.WrUnit.Type        = 'radio_linelabel';
    sProcess.options.WrUnit.Value       = 'sample';
    % === Wd
    sProcess.options.Wd.Class           = 'Window';
    sProcess.options.Wd.Comment         = '<i>W<sub>d</sub></i>: Decision Window (no default, suggested = 20 [sample]): ';
    sProcess.options.Wd.Type            = 'text';
    sProcess.options.Wd.Value           = '20';
    %
    sProcess.options.WdUnit.Class       = 'Window';
    sProcess.options.WdUnit.Comment     = {'[sample]','[ms]','<i>W<sub>d</sub></i> Unit: ';'sample','ms',''};
    sProcess.options.WdUnit.Type        = 'radio_linelabel';
    sProcess.options.WdUnit.Value       = 'sample';
    % === Ws
    sProcess.options.Ws.Class           = 'Window';
    sProcess.options.Ws.Comment         = '<i>W<sub>s</sub></i>: Sliding Window (default = <i>W<sub>r</sub></i> [same as <i>W<sub>r</sub></i>]): ';
    sProcess.options.Ws.Type            = 'text';
    sProcess.options.Ws.Value           = 'Wr';
    %
    sProcess.options.WsUnit.Class       = 'Window';
    sProcess.options.WsUnit.Comment     = {'[sample]', '[ms]', '[same as <i>W<sub>r</sub></i>]', '<i>W<sub>s</sub></i> Unit: '; 'sample', 'ms', 'same', ''};
    sProcess.options.WsUnit.Type        = 'radio_linelabel';
    sProcess.options.WsUnit.Value       = 'same';
    % === Wp
    sProcess.options.Wp.Class           = 'Window';
    sProcess.options.Wp.Comment         = '<i>W<sub>p</sub></i>: Step (default = 1 [sample]): ';
    sProcess.options.Wp.Type            = 'text';
    sProcess.options.Wp.Value           = '1';
    %
    sProcess.options.WpUnit.Class       = 'Window';
    sProcess.options.WpUnit.Comment     = {'[sample]', '[ms]', '[same as <i>W<sub>s</sub></i>]', '<i>W<sub>p</sub></i> Unit: '; 'sample', 'ms', 'same', ''};
    sProcess.options.WpUnit.Type        = 'radio_linelabel';
    sProcess.options.WpUnit.Value       = 'sample';
    % === Wv
    sProcess.options.Wv.Class           = 'Window';
    sProcess.options.Wv.Comment         = '<i>W<sub>v</sub></i>: Overlap (<i>W<sub>v</sub></i> &lt min(<i>W<sub>r</sub></i>,<i>W<sub>s</sub></i>), default = 0 [sample]): ';
    sProcess.options.Wv.Type            = 'text';
    sProcess.options.Wv.Value           = '0';
    %
    sProcess.options.WvUnit.Class       = 'Window';
    sProcess.options.WvUnit.Comment     = {'[sample]', '[ms]', '[same as <i>W<sub>s</sub></i>]', '<i>W<sub>v</sub></i> Unit: '; 'sample', 'ms', 'same', ''};
    sProcess.options.WvUnit.Type        = 'radio_linelabel';
    sProcess.options.WvUnit.Value       = 'sample';
    % === Time Interval to Segment
    sProcess.options.labelIntrv.Class   = 'Interval';
    sProcess.options.labelIntrv.Comment = '<U><B>Time Interval to Segment</B></U>';
    sProcess.options.labelIntrv.Type    = 'label';
    % === Tstart
    sProcess.options.Tstart.Class       = 'Interval';
    sProcess.options.Tstart.Comment     = '<i>T<sub>start</sub></i>: Start Time [s] (leave blank for default = from the start of each file): ';
    sProcess.options.Tstart.Type        = 'text';
    sProcess.options.Tstart.Value       = '';
    % === Tend
    sProcess.options.Tend.Class         = 'Interval';
    sProcess.options.Tend.Comment       = '<i>T<sub>end</sub></i>: End Time [s] (leave blank for default = until the end of each file): ';
    sProcess.options.Tend.Type          = 'text';
    sProcess.options.Tend.Value         = '';
    % === TIncompat
    sProcess.options.TIncompat.Class    = 'Interval';
    sProcess.options.TIncompat.Comment  = {'Ignore Incompatibility', 'Restrict Interval for Global Compatibility', 'Skip Incompatible File(s)', 'Abort', 'On Encountering File(s) Incompatible with Time Interval to Segment: '; 'ignore', 'restrict', 'skip', 'abort', ''};
    sProcess.options.TIncompat.Type     = 'radio_linelabel';
    sProcess.options.TIncompat.Value    = 'ignore';
    % === Preprocessing
    sProcess.options.labelPre.Class     = 'Pre';
    sProcess.options.labelPre.Comment   = '<U><B>Preprocessing</B></U>';
    sProcess.options.labelPre.Type      = 'label';
    % === Domain
    sProcess.options.Domain.Class       = 'Pre';
    sProcess.options.Domain.Comment     = {'Time', 'Frequency (<i>Imaginary Component of Wavelet Cross-Spectrum</i>, *slow*)', 'Phase (<i>Hilbert Transform-Based Analytic Signal</i>)', 'Domain of Analysis: '; 'time', 'frequency', 'phase', ''};
    sProcess.options.Domain.Type        = 'radio_linelabel';
    sProcess.options.Domain.Value       = 'time';
    % === Band
    sProcess.options.Band.Class         = 'Pre';
    sProcess.options.Band.Comment       = '[<i>f<sub>low</sub></i>, <i>f<sub>high</sub></i>]: Frequency Band of Interest [Hz] (0 &le <i>f<sub>low</sub></i> &lt <i>f<sub>high</sub></i>, leave blank for default = <i>Entire Band</i> for Time and Phase Domains, or default = [1, 50] for Frequency Domain): ';
    sProcess.options.Band.Type          = 'text';
    sProcess.options.Band.Value         = '';
    % === AvRemove
    sProcess.options.AvRemove.Class     = 'Pre';
    sProcess.options.AvRemove.Comment   = {'Yes', 'No', 'Reference Space Average Removal (Time Domain only): '; 'yes', 'no', ''};
    sProcess.options.AvRemove.Type      = 'radio_linelabel';
    sProcess.options.AvRemove.Value     = 'no';
    % === VoicesPOct
    sProcess.options.VoicesPOct.Class   = 'Pre';
    sProcess.options.VoicesPOct.Comment = 'Voices per Octave (Frequency Domain only, even number between 4 and 48, default = 4 *higher is slower*): ';
    sProcess.options.VoicesPOct.Type    = 'text';
    sProcess.options.VoicesPOct.Value   = '4';
    sProcess.options.VoicesPOct.Hidden  = 1;
    % === Segment Events
    sProcess.options.Eventlabel.Class   = 'Event';
    sProcess.options.Eventlabel.Comment = '<U><B>Segment Events</B></U>';
    sProcess.options.Eventlabel.Type    = 'label';
    % === Color
    sProcess.options.Color.Class        = 'Event';
    sProcess.options.Color.Comment      = '[<i>R</i>, <i>G</i>, <i>B</i>]: Segment Events Color  (0 &le <i>R</i>, <i>G</i>, <i>B</i> &le 1, default is <i>Blue</i> = [0, 0, 1]): ';
    sProcess.options.Color.Type         = 'text';
    sProcess.options.Color.Value        = '[0, 0, 1]';
    % === ClrPreEvts
    sProcess.options.ClrPreEvts.Class   = 'Event';
    sProcess.options.ClrPreEvts.Comment = {'Yes', 'No', 'Clear Pre-Existing Events: '; 'yes', 'no', ''};
    sProcess.options.ClrPreEvts.Type    = 'radio_linelabel';
    sProcess.options.ClrPreEvts.Value   = 'yes';
    % === seglabel
    sProcess.options.seglabel.Class     = 'Event';
    sProcess.options.seglabel.Comment   = {'Segment Boundary Label: '};
    sProcess.options.seglabel.Type      = 'text';
    sProcess.options.seglabel.Value     = 'SISGMNT';
    sProcess.options.seglabel.Hidden    = 1;
    % === segFileTag
    sProcess.options.segFileTag.Class   = 'Event';
    sProcess.options.segFileTag.Comment = {'Comment Tag Added to Segmented File(s): '};
    sProcess.options.segFileTag.Type    = 'text';
    sProcess.options.segFileTag.Value   = ' | SIS';
    sProcess.options.segFileTag.Hidden  = 1;
    % === Statslabel
    sProcess.options.Statslabel.Class   = 'Stats';
    sProcess.options.Statslabel.Comment = '<U><B>Segmentation Statistics</B></U>';
    sProcess.options.Statslabel.Type    = 'label';
    sProcess.options.Statslabel.Hidden  = 0;
    % === StatBins
    sProcess.options.StatBins.Class     = 'Stats';
    sProcess.options.StatBins.Comment   = 'Time Bins to Count Segment Boundary/Midpoint Recurrences (a vector for bin edges in [s], or a scalar integer for no. of bins, leave blank for default = <i>Auto Detect Bins</i>): ';
    sProcess.options.StatBins.Type      = 'text';
    sProcess.options.StatBins.Value     = '';
    sProcess.options.StatBins.Hidden    = 0;
    % === StatFile
    SelectOptions                       = {'', ...                                           % Filename
                                           '', ...                                           % FileFormat
                                           'save', ...                                       % Dialog type: {open,save}
                                           'Export Segmentation Statistics to File ...', ... % Window title
                                           '', ...                                           % LastUsedDir: {ImportData,ImportChannel,ImportAnat,ExportChannel,ExportData,ExportAnat,ExportProtocol,ExportImage,ExportScript}
                                           'single', ...                                     % Selection mode: {single,multiple}
                                           'files', ...                                      % Selection mode: {files,dirs,files_and_dirs}
                                           {'.mat', 'MATLAB data file (*.mat)', 'MAT'}, ...  % Get all the available file formats
                                           ''};                                              % DefaultFormats: {ChannelIn,DataIn,DipolesIn,EventsIn,MriIn,NoiseCovIn,ResultsIn,SspIn,SurfaceIn,TimefreqIn
    sProcess.options.StatFile.Class     = 'Stats';
    sProcess.options.StatFile.Comment   = 'Export Segmentation Statistics to File: ';
    sProcess.options.StatFile.Type      = 'filename';
    sProcess.options.StatFile.Value     = SelectOptions;
    % === AvNxtBound
    sProcess.options.AvNxtBound.Class   = 'Stats';
    sProcess.options.AvNxtBound.Comment = {'Yes', 'No', 'Show Average duration to Encompassing Segment End: '; 'yes', 'no', ''};
    sProcess.options.AvNxtBound.Type    = 'radio_linelabel';
    sProcess.options.AvNxtBound.Value   = 'no';
    sProcess.options.AvNxtBound.Hidden  = 1;
    % === Note
    sProcess.options.Note.Class         = 'Note';
    sProcess.options.Note.Comment       = '<U><B>Note:</B></U> Window and interval parameters can be passed as expressions that may include previously defined parameters, in the sequence of their appearance above, using the unsubscripted notation (Wr, Wd, Ws, Wp, Wv, Tstart, Tend).<br><i>Examples</i>: 20*1000/512, Ws-1, ceil(Wr/2), Tstart+2. All window parameters in [ms] units, except <i>W<sub>v</sub></i>, are rounded to the higher integer [sample] value, depending on the sampling rate of each file. <i>W<sub>v</sub></i> is rounded to the lower integer [sample] value.';
    sProcess.options.Note.Type          = 'label';
    % === Author
    sProcess.options.Author.Class       = 'Author';
    sProcess.options.Author.Comment     = '<B>Ali Haddad</B>, Sept. 2020, <i>e-mail</i>:<a href="mailto:ali.haddad@rutgers.edu">ali.haddad@rutgers.edu</a>; for citation see Online tutorial';
    sProcess.options.Author.Type        = 'label';
end


%% ===== FORMAT COMMENT =====
function Comment = FormatComment(sProcess) %#ok<INUSD,DEFNU>
    Comment = 'Source-Informed Segmentation: estimates the intervals during which the dynamic functional networks in the brain retain the stationarity of their connectivity.  (Ali Haddad, Sept. 2020, email:ali.haddad@rutgers.edu; for citation see Online tutorial)';
end


%% ===== RUN =====
function OutputFiles = Run(sProcess, sInputA, sInputB) %#ok<DEFNU>
    bst_progress('text', 'Initializing...');
    % Get option values
    WrUnit             = sProcess.options.WrUnit.Value;
    if isempty(sProcess.options.Wr.Value) || prod(isspace(sProcess.options.Wr.Value))
        bst_report('Error', 'process_SISegmentationMD2', '', 'Initial Reference Window (Wr) undefined!');
        return
    else
        Wr             = eval(sProcess.options.Wr.Value);
        if ~isnumeric(Wr) || ~isscalar(Wr) || (Wr<=0)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Initial Reference Window (Wr) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WrUnit,'sample') && (round(Wr)~=Wr)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Initial Reference Window (Wr) is passed as non-integer [sample]!');
            return
        end
    end
    WdUnit             = sProcess.options.WdUnit.Value;
    if isempty(sProcess.options.Wd.Value) || prod(isspace(sProcess.options.Wd.Value))
        bst_report('Error', 'process_SISegmentationMD2', '', 'Decision Window (Wd) undefined!');
        return
    else
        Wd             = eval(sProcess.options.Wd.Value);
        if ~isnumeric(Wd) || ~isscalar(Wd) || (Wd<=0)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Decision Window (Wd) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WdUnit,'sample') && (round(Wd)~=Wd)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Decision Window (Wd) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Ws.Value) || prod(isspace(sProcess.options.Ws.Value))
        WsUnit         = WrUnit;
        Ws             = Wr;
        bst_report('Warning', 'process_SISegmentationMD2', '', 'Sliding Window (Ws) is set to default value.');
    else
        if strcmp(sProcess.options.WsUnit.Value, 'same')
            WsUnit     = WrUnit;
        else
            WsUnit     = sProcess.options.WsUnit.Value;
        end
        Ws             = eval(sProcess.options.Ws.Value);
        if ~isnumeric(Ws) || ~isscalar(Ws) || (Ws<=0)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Sliding Window (Ws) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WsUnit,'sample') && (round(Ws)~=Ws)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Sliding Window (Ws) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Wp.Value) || prod(isspace(sProcess.options.Wp.Value))
        WpUnit         = 'sample';
        Wp             = 1;
        bst_report('Warning', 'process_SISegmentationMD2', '', 'Step (Wp) is set to default value.');
    else
        if strcmp(sProcess.options.WpUnit.Value, 'same')
            WpUnit     = WsUnit;
        else
            WpUnit     = sProcess.options.WpUnit.Value;
        end
        Wp             = eval(sProcess.options.Wp.Value);
        if ~isnumeric(Wp) || ~isscalar(Wp) || (Wp<=0)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Step (Wp) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WpUnit,'sample') && (round(Wp)~=Wp)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Step (Wp) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Wv.Value) || prod(isspace(sProcess.options.Wv.Value))
        WvUnit         = 'sample';
        Wv             = 0;
        bst_report('Warning', 'process_SISegmentationMD2', '', 'Overlap (Wv) is set to default value.');
    else
        if strcmp(sProcess.options.WvUnit.Value, 'same')
            WvUnit     = WsUnit;
        else
            WvUnit     = sProcess.options.WvUnit.Value;
        end
        Wv             = eval(sProcess.options.Wv.Value);
        if ~isnumeric(Wv) || ~isscalar(Wv) || (Wv<0)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Overlap (Wv) needs to be a scalar equal to 0 or higher!');
            return
        elseif strcmp(WvUnit,'sample') && (round(Wv)~=Wv)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Overlap (Wv) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Tstart.Value) || prod(isspace(sProcess.options.Tstart.Value))
        Tstart         = [];
    else
        Tstart         = eval(sProcess.options.Tstart.Value);
        if ~isnumeric(Tstart) || ~isscalar(Tstart)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Start Time (Tstart) needs to be a scalar!');
            return
        end
    end
    if isempty(sProcess.options.Tend.Value) || prod(isspace(sProcess.options.Tend.Value))
        Tend           = [];
    else
        Tend           = eval(sProcess.options.Tend.Value);
        if ~isnumeric(Tend) || ~isscalar(Tend)
            bst_report('Error', 'process_SISegmentationMD2', '', 'End Time (Tend) needs to be a scalar!');
            return
        end
    end
    Domain             = sProcess.options.Domain.Value;
    if isempty(sProcess.options.Band.Value) || prod(isspace(sProcess.options.Band.Value))
        switch Domain
            case {'time', 'phase'}
                Band   = [];
            case 'frequency'
                Band   = [1, 50];
        end
    else
        Band           = eval(sProcess.options.Band.Value);
        if strcmp(Domain,'frequency') && isnumeric(Band) && isempty(Band)
            Band       = [1, 50];
            bst_report('Warning', 'process_SISegmentationMD2', '', 'Frequency Band of Interest cannnot be empty (Entire Band) for Frequency Domain Analysis. It is set to default band.');
        elseif ~isnumeric(Band) || ~isequal(size(Band),[1,2]) || (Band(1)<0) || (Band(1)>=Band(2))
            bst_report('Error', 'process_SISegmentationMD2', '', 'Frequency Band of Interest is not in the correct format!');
            return
        end
    end
    if isempty(sProcess.options.VoicesPOct.Value) || prod(isspace(sProcess.options.VoicesPOct.Value))
        VoicesPOct     = 4;
        bst_report('Warning', 'process_SISegmentationMD2', '', 'Voices Per Octave is set to default value.');
    else
        VoicesPOct     = eval(sProcess.options.VoicesPOct.Value);
        if ~isnumeric(VoicesPOct) || ~isscalar(VoicesPOct) || (VoicesPOct<4) || (VoicesPOct>48) || (round(VoicesPOct/2)~=(VoicesPOct/2))
            bst_report('Error', 'process_SISegmentationMD2', '', 'Voices Per Octave needs to be an even scalar between 4 and 48!');
            return
        end
    end
    if isempty(sProcess.options.Color.Value) || prod(isspace(sProcess.options.Color.Value))
        Color          = [0, 0, 1];
        bst_report('Warning', 'process_SISegmentationMD2', '', 'Segment Events Color is set to its default.');
    else
        Color          = eval(sProcess.options.Color.Value);
        if isnumeric(Color) && isempty(Color)
            Color      = [0, 0, 1];
            bst_report('Warning', 'process_SISegmentationMD2', '', 'Segment Events Color is set to its default.');
        elseif ~isnumeric(Color) || ~isequal(size(Color),[1,3]) || sum(Color<0) || sum(Color>1)
            bst_report('Error', 'process_SISegmentationMD2', '', 'Segment Events Color is not in the correct format!');
            return
        end
    end
    if isempty(sProcess.options.StatBins.Value) || prod(isspace(sProcess.options.StatBins.Value))
        StatBins       = [];
    else
        StatBins       = eval(sProcess.options.StatBins.Value);
        if ~isnumeric(StatBins) || (isscalar(StatBins)&&(round(StatBins)~=StatBins)) || (length(StatBins)~=numel(StatBins))
            bst_report('Error', 'process_SISegmentationMD2', '', 'Time Bins not in a correct format!');
            return
        end
    end
    TIncompat          = sProcess.options.TIncompat.Value;
    switch sProcess.options.AvRemove.Value
        case 'yes'
            AvRemove   = true;
        case 'no'
            AvRemove   = false;
    end
    switch sProcess.options.ClrPreEvts.Value
        case 'yes'
            ClrPreEvts = true;
        case 'no'
            ClrPreEvts = false;
    end
    seglabel           = sProcess.options.seglabel.Value;
    segFileTag         = sProcess.options.segFileTag.Value;
    StatFile           = sProcess.options.StatFile.Value{1};
    switch sProcess.options.AvNxtBound.Value
        case 'yes'
            AvNxtBound = true;
        case 'no'
            AvNxtBound = false;
    end
    % Checking compatibility of input file(s) with time interval to segment
    bst_progress('text', 'Checking file compatibility...');
    nFileA           = length(sInputA);
    TboundA          = zeros(nFileA, 2);
    srateA           = zeros(nFileA, 1);
    idxFileA         = 1:nFileA;
    for i = idxFileA
        TimeVectorA  = in_bst(sInputA(i).FileName, 'Time');
        TboundA(i,:) = [TimeVectorA(1), TimeVectorA(end)];
        srateA(i)    = 1 / (TimeVectorA(2)-TimeVectorA(1));
    end
    nFileB           = length(sInputB);
    TboundB          = zeros(nFileB, 2);
    srateB           = zeros(nFileB, 1);
    idxFileB         = 1:nFileB;
    for i = idxFileB
        TimeVectorB  = in_bst(sInputB(i).FileName, 'Time');
        TboundB(i,:) = [TimeVectorB(1), TimeVectorB(end)];
        srateB(i)    = 1 / (TimeVectorB(2)-TimeVectorB(1));
    end
    if isempty(Tstart)
        Tstart       = min([TboundA(:,1);TboundB(:,1)]);
    end
    if isempty(Tend)
        Tend         = max([TboundA(:,2);TboundB(:,2)]);
    end
    if Tend <= Tstart
        bst_report('Error', 'process_SISegmentationMD2', '', 'End Time (Tend) needs to be higher than Start Time (Tstart)!');
        return
    end
    incompatA        = or(TboundA(:,1)>Tstart, TboundA(:,2)<Tend)';
    incompatB        = or(TboundB(:,1)>Tstart, TboundB(:,2)<Tend)';
    Trestrict        = [max([TboundA(:,1);TboundB(:,1);Tstart]), min([TboundA(:,2);TboundB(:,2);Tend])];
    % Handling incompatibilities with time interval to segment and inequality of sampling rates
    if (sum(incompatA)+sum(incompatB)) > 0
        switch TIncompat
            case 'ignore'
                if Trestrict(2) <= Trestrict(1)
                    bst_report('Warning', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Ignored the incompatibility of ',num2str(sum(incompatA)+sum(incompatB)),' file(s) with the Time Interval to Segment. All ',num2str(nFileA+nFileB),' file(s) processed. Note: no globally compatible time interval found.']);
                else
                    bst_report('Warning', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Ignored the incompatibility of ',num2str(sum(incompatA)+sum(incompatB)),' file(s) with the Time Interval to Segment. All ',num2str(nFileA+nFileB),' file(s) processed. Note: the strictest globally compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                end
                TInterval       = [Tstart, Tend];
                idxProcessFileA = idxFileA;
                idxProcessFileB = idxFileB;
            case 'restrict'
                if Trestrict(2) <= Trestrict(1)
                    bst_report('Error', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, 'No globally compatible time interval to Segment found! No file(s) processed.');
                    return
                else
                    bst_report('Warning', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Restricted the Time Interval to Segment to: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s] for global compatibility. All ',num2str(nFileA+nFileB),' file(s) processed accordingly. Note: ',num2str(sum(incompatA)+sum(incompatB)),' file(s) found incompatible with the user-input interval.']);
                end
                TInterval       = Trestrict;
                idxProcessFileA = idxFileA;
                idxProcessFileB = idxFileB;
            case 'skip'
                if (sum(incompatA)>=nFileA) && (Trestrict(2)<=Trestrict(1))
                    bst_report('Error', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Skipped ',num2str(sum(incompatA)+sum(incompatB)),' file(s) incompatible with the Time Interval to Segment. No remaining files to process on "Files A" side! Note: no globally compatible time interval found.']);
                    return
                elseif sum(incompatA) >= nFileA
                    bst_report('Error', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Skipped ',num2str(sum(incompatA)+sum(incompatB)),' file(s) incompatible with the Time Interval to Segment. No remaining files to process on "Files A" side! Note: the strictest globally compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                    return
                elseif (sum(incompatB)>=nFileB) && (Trestrict(2)<=Trestrict(1))
                    bst_report('Error', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Skipped ',num2str(sum(incompatA)+sum(incompatB)),' file(s) incompatible with the Time Interval to Segment. No remaining files to process on "Files B" side! Note: no globally compatible time interval found.']);
                    return
                elseif sum(incompatB) >= nFileB
                    bst_report('Error', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Skipped ',num2str(sum(incompatA)+sum(incompatB)),' file(s) incompatible with the Time Interval to Segment. No remaining files to process on "Files B" side! Note: the strictest globally compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                    return
                elseif Trestrict(2) <= Trestrict(1)
                    bst_report('Warning', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Skipped ',num2str(sum(incompatA)+sum(incompatB)),' file(s) incompatible with the Time Interval to Segment. The remaining ',num2str(nFileA-sum(incompatA)+nFileB-sum(incompatB)),' file(s) processed. Note: no globally compatible time interval found.']);
                else
                    bst_report('Warning', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Skipped ',num2str(sum(incompatA)+sum(incompatB)),' file(s) incompatible with the Time Interval to Segment. The remaining ',num2str(nFileA-sum(incompatA)+nFileB-sum(incompatB)),' file(s) processed. Note: the strictest globally compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                end
                TInterval       = [Tstart, Tend];
                idxProcessFileA = idxFileA(~incompatA);
                idxProcessFileB = idxFileB(~incompatB);
            case 'abort'
                if Trestrict(2) <= Trestrict(1)
                    bst_report('Error', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Aborted. ',num2str(sum(incompatA)+sum(incompatB)),' file(s) found incompatible with the Time Interval to Segment! No file(s) processed. Note: no globally compatible time interval found.']);
                else
                    bst_report('Error', 'process_SISegmentationMD2', {sInputA(incompatA).FileName,sInputB(incompatB).FileName}, ['Aborted. ',num2str(sum(incompatA)+sum(incompatB)),' file(s) found incompatible with the Time Interval to Segment! No file(s) processed. Note: the strictest compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                end
                return
        end
    else
        TInterval               = [Tstart, Tend];
        idxProcessFileA         = idxFileA;
        idxProcessFileB         = idxFileB;
    end
    if sum(srateA(idxProcessFileA(1)) ~= [srateA(idxProcessFileA);srateB(idxProcessFileB)])
        bst_report('Warning', 'process_SISegmentationMD2', {sInputA(idxProcessFileA).FileName,sInputB(idxProcessFileB).FileName}, ['Sampling rate varied between: ',num2str(min([srateA(idxProcessFileA);srateB(idxProcessFileB)])),' and ',num2str(max([srateA(idxProcessFileA);srateB(idxProcessFileB)])),' [sample/s] across the processed files.']);
    end 
    if ~isempty(Band) && (Band(1)>=min([srateA(idxProcessFileA);srateB(idxProcessFileB)])/2)
        BincompatA              = Band(1) >= srateA/2; % All incompatibilities
        BincompatB              = Band(1) >= srateB/2;
        bst_report('Error', 'process_SISegmentationMD2', {sInputA(BincompatA).FileName,sInputB(BincompatB).FileName}, [num2str(sum(BincompatA)+sum(BincompatB)),' file(s) incompatible with the Frequqncy Band of Interest!']);
        return
    end
    OutputFiles = cell(1, length(idxProcessFileA)+length(idxProcessFileB));
    % Processing input file(s) A
    bst_progress('text', 'Segmenting file(s)...');
    AllTimeVecA = cell(1, length(idxProcessFileA));
    BoundA      = cell(2, length(idxProcessFileA));
    PropBoundA  = cell(1, length(idxProcessFileA));
    PropLENA    = cell(1, length(idxProcessFileA));
    MAXLENA     = zeros(2, length(idxProcessFileA));
    MINLENA     = zeros(2, length(idxProcessFileA));
    idx         = 0;
    for i = idxProcessFileA
        idx = idx + 1;
        % ===== LOAD THE DATA =====
        % Read file #i
        DataMat                   = in_bst(sInputA(i).FileName, TInterval);
        if ~isfield(DataMat, 'SISegment') && ~ClrPreEvts
            preINFO               = in_bst_data(sInputA(i).FileName, 'SISegment');
            if ~isempty(preINFO.SISegment)
                DataMat.SISegment = preINFO.SISegment;
            end
        elseif isfield(DataMat, 'SISegment') && ClrPreEvts
            DataMat               = rmfield(DataMat, 'SISegment');
        end
        AllTimeVecA{idx}          = DataMat.Time;
        % Convert window parameters to [sample] if necessary
        switch WrUnit
            case 'sample'
                W_r = Wr;
            case 'ms'
                W_r = ceil(Wr * srateA(i) / 1000);
        end
        switch WdUnit
            case 'sample'
                W_d = Wd;
            case 'ms'
                W_d = ceil(Wd * srateA(i) / 1000);
        end
        switch WsUnit
            case 'sample'
                W_s = Ws;
            case 'ms'
                W_s = ceil(Ws * srateA(i) / 1000);
        end
        switch WpUnit
            case 'sample'
                W_p = Wp;
            case 'ms'
                W_p = ceil(Wp * srateA(i) / 1000);
        end
        switch WvUnit
            case 'sample'
                W_v = Wv;
            case 'ms'
                W_v = floor(Wv * srateA(i) / 1000);
        end
        if W_v >= min(W_r,W_s)
            bst_report('Error', 'process_SISegmentationMD2', sInputA(i).FileName, 'Overlap (Wv) needs to satisfy Wv < min(Wr,Ws)!');
            return
        end
        % ===== PROCESS =====
        [SEGPNTS, INFO]       = Compute(DataMat.F, W_r, W_d, W_s, W_p, W_v, Domain, AvRemove, Band, srateA(i), [idx-1,length(idxProcessFileA)+length(idxProcessFileB)], VoicesPOct);
        nsegs                 = length(SEGPNTS);
        BoundA{1, idx}        = AllTimeVecA{idx}(SEGPNTS);
        BoundA{2, idx}        = [AllTimeVecA{idx}(SEGPNTS(2:nsegs)-1), AllTimeVecA{idx}(end)];
        PropBoundA{idx}       = BoundA{1, idx}(2:nsegs);
        PropLENA{idx}         = 1000 * (BoundA{2, idx}(2:nsegs)-BoundA{1, idx}(2:nsegs)); % [ms]
        [MAXLENA(2,idx), seq] = max(1000 * (BoundA{2,idx}-BoundA{1,idx}));
        MAXLENA(1,idx)        = AllTimeVecA{idx}(SEGPNTS(seq));
        [MINLENA(2,idx), seq] = min(1000 * (BoundA{2,idx}-BoundA{1,idx}));
        MINLENA(1,idx)        = AllTimeVecA{idx}(SEGPNTS(seq));
        % ===== SAVE THE RESULTS =====
        % Update data file structure
        if ~isfield(DataMat, 'Events')
            Nevt_prev     = 0;
            NSIS_prev     = 0;
        elseif ClrPreEvts
            DataMat       = rmfield(DataMat, 'Events');
            Nevt_prev     = 0;
            NSIS_prev     = 0;
        else
            Nevt_prev     = length(DataMat.Events);
            if Nevt_prev > 0
                NSIS_prev = length(cell2mat(strfind({DataMat.Events.label}, seglabel)));
            else
                NSIS_prev = 0;
            end
        end
        if NSIS_prev == 0
            labelext      = '';
        else
            labelext      = ['(', num2str(NSIS_prev+1), ')'];
        end
        Notes             = cell(1, nsegs);
        for seg = 1:nsegs
            Notes{seg}    = num2str(seg);
        end
        if isempty(Band)
            HNBs          = '[ ]';
        else
            HNBs          = ['[', num2str(Band(1)), ',', num2str(Band(2)), '] [Hz]'];
        end
        Hnotes            = ['label=',        seglabel,labelext, ', ', ...
                             'Wr=',           num2str(W_r),      ', ', ...
                             'Wd=',           num2str(W_d),      ', ', ...
                             'Ws=',           num2str(W_s),      ', ', ...
                             'Wp=',           num2str(W_p),      ', ', ...
                             'Wv=',           num2str(W_v),      ', ', ...
                             'unit=',         '[sample]',        ', ', ...
                             'Domain=',       Domain,            ', ', ...
                             '[flow,fhigh]=', HNBs,              ', ', ...
                             'AvRemove=',     num2str(AvRemove)];
        INFO.label        = [seglabel, labelext];
        if isempty(strfind(DataMat.Comment, segFileTag))
            DataMat.Comment                    = [DataMat.Comment, segFileTag];
        end
        DataMat.Events(Nevt_prev+1).label      = [seglabel, labelext];
        DataMat.Events(Nevt_prev+1).color      = Color;
        DataMat.Events(Nevt_prev+1).epochs     = ones(1,nsegs);
        DataMat.Events(Nevt_prev+1).times      = [BoundA{1, idx}; BoundA{2, idx}];
        DataMat.Events(Nevt_prev+1).reactTimes = [];
        DataMat.Events(Nevt_prev+1).select     = 1;
        DataMat.Events(Nevt_prev+1).channels   = cell(1,nsegs);
        DataMat.Events(Nevt_prev+1).notes      = Notes;
        if ~isfield(DataMat, 'History')
            DataMat.History                    = {datetime, 'Source-Informed Segmentation', Hnotes};
        else
            Nhst_prev                          = size(DataMat.History, 1);
            DataMat.History{Nhst_prev+1,1}     = datetime;
            DataMat.History{Nhst_prev+1,2}     = 'Source-Informed Segmentation';
            DataMat.History{Nhst_prev+1,3}     = Hnotes;
        end
        if ~isfield(DataMat, 'SISegment')
            DataMat.SISegment(1)               = INFO;
        else
            Ninf_prev                          = length(DataMat.SISegment);
            DataMat.SISegment(Ninf_prev+1)     = INFO;
        end
        % Create output filename
        [FilePath, FileName] = fileparts(sInputA(i).FileName);
        OutputFiles{idx}     = bst_process('GetNewFilename', FilePath, [FileName,'_SIS',labelext]);
        % Save on disk
        save(OutputFiles{idx}, '-struct', 'DataMat');
        % Get output study (pick the one from the respective original file(s))
        iStudy = sInputA(i).iStudy;
        % Register in the database
        db_add_data(iStudy, OutputFiles{idx}, DataMat);
    end
    % Processing input file(s) B
    AllTimeVecB = cell(1, length(idxProcessFileB));
    BoundB      = cell(2, length(idxProcessFileB));
    PropBoundB  = cell(1, length(idxProcessFileB));
    PropLENB    = cell(1, length(idxProcessFileB));
    MAXLENB     = zeros(2, length(idxProcessFileB));
    MINLENB     = zeros(2, length(idxProcessFileB));
    idx         = 0;
    for i = idxProcessFileB
        idx = idx + 1;
        % ===== LOAD THE DATA =====
        % Read file #i
        DataMat                   = in_bst(sInputB(i).FileName, TInterval);
        if ~isfield(DataMat, 'SISegment') && ~ClrPreEvts
            preINFO               = in_bst_data(sInputB(i).FileName, 'SISegment');
            if ~isempty(preINFO.SISegment)
                DataMat.SISegment = preINFO.SISegment;
            end
        elseif isfield(DataMat, 'SISegment') && ClrPreEvts
            DataMat               = rmfield(DataMat, 'SISegment');
        end
        AllTimeVecB{idx}          = DataMat.Time;
        % Convert window parameters to [sample] if necessary
        switch WrUnit
            case 'sample'
                W_r = Wr;
            case 'ms'
                W_r = ceil(Wr * srateB(i) / 1000);
        end
        switch WdUnit
            case 'sample'
                W_d = Wd;
            case 'ms'
                W_d = ceil(Wd * srateB(i) / 1000);
        end
        switch WsUnit
            case 'sample'
                W_s = Ws;
            case 'ms'
                W_s = ceil(Ws * srateB(i) / 1000);
        end
        switch WpUnit
            case 'sample'
                W_p = Wp;
            case 'ms'
                W_p = ceil(Wp * srateB(i) / 1000);
        end
        switch WvUnit
            case 'sample'
                W_v = Wv;
            case 'ms'
                W_v = floor(Wv * srateB(i) / 1000);
        end
        if W_v >= min(W_r,W_s)
            bst_report('Error', 'process_SISegmentationMD2', sInputB(i).FileName, 'Overlap (Wv) needs to satisfy Wv < min(Wr,Ws)!');
            return
        end
        % ===== PROCESS =====
        [SEGPNTS, INFO]       = Compute(DataMat.F, W_r, W_d, W_s, W_p, W_v, Domain, AvRemove, Band, srateB(i), [length(idxProcessFileA)+idx-1,length(idxProcessFileA)+length(idxProcessFileB)], VoicesPOct);
        nsegs                 = length(SEGPNTS);
        BoundB{1, idx}        = AllTimeVecB{idx}(SEGPNTS);
        BoundB{2, idx}        = [AllTimeVecB{idx}(SEGPNTS(2:nsegs)-1), AllTimeVecB{idx}(end)];
        PropBoundB{idx}       = BoundB{1, idx}(2:nsegs);
        PropLENB{idx}         = 1000 * (BoundB{2, idx}(2:nsegs)-BoundB{1, idx}(2:nsegs)); % [ms]
        [MAXLENB(2,idx), seq] = max(1000 * (BoundB{2,idx}-BoundB{1,idx}));
        MAXLENB(1,idx)        = AllTimeVecB{idx}(SEGPNTS(seq));
        [MINLENB(2,idx), seq] = min(1000 * (BoundB{2,idx}-BoundB{1,idx}));
        MINLENB(1,idx)        = AllTimeVecB{idx}(SEGPNTS(seq));
        % ===== SAVE THE RESULTS =====
        % Update data file structure
        if ~isfield(DataMat, 'Events')
            Nevt_prev     = 0;
            NSIS_prev     = 0;
        elseif ClrPreEvts
            DataMat       = rmfield(DataMat, 'Events');
            Nevt_prev     = 0;
            NSIS_prev     = 0;
        else
            Nevt_prev     = length(DataMat.Events);
            if Nevt_prev > 0
                NSIS_prev = length(cell2mat(strfind({DataMat.Events.label}, seglabel)));
            else
                NSIS_prev = 0;
            end
        end
        if NSIS_prev == 0
            labelext      = '';
        else
            labelext      = ['(', num2str(NSIS_prev+1), ')'];
        end
        Notes             = cell(1, nsegs);
        for seg = 1:nsegs
            Notes{seg}    = num2str(seg);
        end
        if isempty(Band)
            HNBs          = '[ ]';
        else
            HNBs          = ['[', num2str(Band(1)), ',', num2str(Band(2)), '] [Hz]'];
        end
        Hnotes            = ['label=',        seglabel,labelext, ', ', ...
                             'Wr=',           num2str(W_r),      ', ', ...
                             'Wd=',           num2str(W_d),      ', ', ...
                             'Ws=',           num2str(W_s),      ', ', ...
                             'Wp=',           num2str(W_p),      ', ', ...
                             'Wv=',           num2str(W_v),      ', ', ...
                             'unit=',         '[sample]',        ', ', ...
                             'Domain=',       Domain,            ', ', ...
                             '[flow,fhigh]=', HNBs,              ', ', ...
                             'AvRemove=',     num2str(AvRemove)];
        INFO.label        = [seglabel, labelext];
        if isempty(strfind(DataMat.Comment, segFileTag))
            DataMat.Comment                    = [DataMat.Comment, segFileTag];
        end
        DataMat.Events(Nevt_prev+1).label      = [seglabel, labelext];
        DataMat.Events(Nevt_prev+1).color      = Color;
        DataMat.Events(Nevt_prev+1).epochs     = ones(1,nsegs);
        DataMat.Events(Nevt_prev+1).times      = [BoundB{1, idx}; BoundB{2, idx}];
        DataMat.Events(Nevt_prev+1).reactTimes = [];
        DataMat.Events(Nevt_prev+1).select     = 1;
        DataMat.Events(Nevt_prev+1).channels   = cell(1,nsegs);
        DataMat.Events(Nevt_prev+1).notes      = Notes;
        if ~isfield(DataMat, 'History')
            DataMat.History                    = {datetime, 'Source-Informed Segmentation', Hnotes};
        else
            Nhst_prev                          = size(DataMat.History, 1);
            DataMat.History{Nhst_prev+1,1}     = datetime;
            DataMat.History{Nhst_prev+1,2}     = 'Source-Informed Segmentation';
            DataMat.History{Nhst_prev+1,3}     = Hnotes;
        end
        if ~isfield(DataMat, 'SISegment')
            DataMat.SISegment(1)               = INFO;
        else
            Ninf_prev                          = length(DataMat.SISegment);
            DataMat.SISegment(Ninf_prev+1)     = INFO;
        end
        % Create output filename
        [FilePath, FileName]                     = fileparts(sInputB(i).FileName);
        OutputFiles{idx+length(idxProcessFileA)} = bst_process('GetNewFilename', FilePath, [FileName,'_SIS',labelext]);
        % Save on disk
        save(OutputFiles{idx+length(idxProcessFileA)}, '-struct', 'DataMat');
        % Get output study (pick the one from the respective original file(s))
        iStudy = sInputB(i).iStudy;
        % Register in the database
        db_add_data(iStudy, OutputFiles{idx+length(idxProcessFileA)}, DataMat);
    end
    % Segmentation statistics
    bst_progress('text', 'Generating Statistics...');
    BoundMatA          = cell2mat(BoundA);
    BoundMatB          = cell2mat(BoundB);
    if isempty(StatBins)
        [~, edgesB]    = histcounts([cell2mat(PropBoundA),cell2mat(PropBoundB)], 'BinLimits',TInterval);
        [~, edgesM]    = histcounts([mean(BoundMatA,1),mean(BoundMatB,1)], 'BinLimits',TInterval);
    elseif isscalar(StatBins)
        [~, edgesB]    = histcounts([cell2mat(PropBoundA),cell2mat(PropBoundB)], StatBins, 'BinLimits',TInterval);
        [~, edgesM]    = histcounts([mean(BoundMatA,1),mean(BoundMatB,1)], StatBins, 'BinLimits',TInterval);
    else
        [~, edgesB]    = histcounts([cell2mat(PropBoundA),cell2mat(PropBoundB)], StatBins);
        [~, edgesM]    = histcounts([mean(BoundMatA,1),mean(BoundMatB,1)], StatBins);
    end
    HBA                = histcounts(cell2mat(PropBoundA), edgesB);
    HBB                = histcounts(cell2mat(PropBoundB), edgesB);
    HMA                = histcounts(mean(BoundMatA,1), edgesM);
    HMB                = histcounts(mean(BoundMatB,1), edgesM);
    if (sum(incompatA)>0) && strcmp(TIncompat,'ignore')
        for i = 1:length(HBA)
            if HBA(i) > 0
                HBA(i) = HBA(i) * (edgesB(i+1)-edgesB(i)) / sum(max(min(edgesB(i+1),TboundA(idxProcessFileA,2))-max(edgesB(i),TboundA(idxProcessFileA,1)),0));
            end
        end
        for i = 1:length(HMA)
            if HMA(i) > 0
                HMA(i) = HMA(i) * (edgesM(i+1)-edgesM(i)) / sum(max(min(edgesM(i+1),TboundA(idxProcessFileA,2))-max(edgesM(i),TboundA(idxProcessFileA,1)),0));
            end
        end
    else
        HBA            = HBA / length(idxProcessFileA);
        HMA            = HMA / length(idxProcessFileA);
    end
    if (sum(incompatB)>0) && strcmp(TIncompat,'ignore')
        for i = 1:length(HBB)
            if HBB(i) > 0
                HBB(i) = HBB(i) * (edgesB(i+1)-edgesB(i)) / sum(max(min(edgesB(i+1),TboundB(idxProcessFileB,2))-max(edgesB(i),TboundB(idxProcessFileB,1)),0));
            end
        end
        for i = 1:length(HMB)
            if HMB(i) > 0
                HMB(i) = HMB(i) * (edgesM(i+1)-edgesM(i)) / sum(max(min(edgesM(i+1),TboundB(idxProcessFileB,2))-max(edgesM(i),TboundB(idxProcessFileB,1)),0));
            end
        end
    else
        HBB            = HBB / length(idxProcessFileB);
        HMB            = HMB / length(idxProcessFileB);
    end
    SEGLENA            = 1000 * diff(BoundMatA,1,1); % [ms]
    SEGLENB            = 1000 * diff(BoundMatB,1,1);
    timesP             = unique([cell2mat(AllTimeVecA), cell2mat(AllTimeVecB)])';
    LENavA             = zeros(size(timesP));
    LENsdA             = zeros(size(timesP));
    NXTavA             = zeros(size(timesP));
    NXTsdA             = zeros(size(timesP));
    LENavB             = zeros(size(timesP));
    LENsdB             = zeros(size(timesP));
    NXTavB             = zeros(size(timesP));
    NXTsdB             = zeros(size(timesP));
    for i = 1:length(timesP)
        SEL            = and(timesP(i)>=BoundMatA(1,:), timesP(i)<=BoundMatA(2,:));
        LENavA(i)      = mean(SEGLENA(SEL));
        LENsdA(i)      = std(SEGLENA(SEL));
        NXTavA(i)      = mean(1000 * (BoundMatA(2,SEL)-timesP(i)));
        NXTsdA(i)      = std(1000 * (BoundMatA(2,SEL)-timesP(i)));
        SEL            = and(timesP(i)>=BoundMatB(1,:), timesP(i)<=BoundMatB(2,:));
        LENavB(i)      = mean(SEGLENB(SEL));
        LENsdB(i)      = std(SEGLENB(SEL));
        NXTavB(i)      = mean(1000 * (BoundMatB(2,SEL)-timesP(i)));
        NXTsdB(i)      = std(1000 * (BoundMatB(2,SEL)-timesP(i)));
    end
    AVdynA             = trapz(timesP,LENavA) / (TInterval(2)-TInterval(1));
    SDdynA             = (trapz(timesP,(LENavA-AVdynA).^2)/(TInterval(2)-TInterval(1))) ^ 0.5;
    AVdynB             = trapz(timesP,LENavB) / (TInterval(2)-TInterval(1));
    SDdynB             = (trapz(timesP,(LENavB-AVdynB).^2)/(TInterval(2)-TInterval(1))) ^ 0.5;
    PCORR              = trapz(timesP,(LENavA-AVdynA).*(LENavB-AVdynB)) / (SDdynA*SDdynB*(TInterval(2)-TInterval(1)));
    AVA                = mean(SEGLENA);
    SDA                = std(SEGLENA);
    AVB                = mean(SEGLENB);
    SDB                = std(SEGLENB);
    AVmaxA             = mean(MAXLENA(2,:));
    SDmaxA             = std(MAXLENA(2,:));
    AVminA             = mean(MINLENA(2,:));
    SDminA             = std(MINLENA(2,:));
    AVmaxB             = mean(MAXLENB(2,:));
    SDmaxB             = std(MAXLENB(2,:));
    AVminB             = mean(MINLENB(2,:));
    SDminB             = std(MINLENB(2,:));
    [~, kspval]        = kstest2(SEGLENA, SEGLENB);
    [~, bikspvalbound] = Compute_bikstest2([cell2mat(PropBoundA);cell2mat(PropLENA)]', [cell2mat(PropBoundB);cell2mat(PropLENB)]');
    [~, bikspvalmidp]  = Compute_bikstest2([mean(BoundMatA,1);SEGLENA]', [mean(BoundMatB,1);SEGLENB]');
    % Plot statistics
    allow_ntcks        = 25; % Allowed number of histogram ticks
    figure('name', 'Segmentation Statistics')
    set(gcf, 'windowstate','maximized');
    subplot(2, 2, 1)
    hold on
    histogram('BinEdges',edgesB, 'BinCounts',HBA, 'FaceColor','b', 'FaceAlpha',0.5, 'EdgeColor','b', 'EdgeAlpha',1);
    histogram('BinEdges',edgesB, 'BinCounts',HBB, 'FaceColor','r', 'FaceAlpha',0.5, 'EdgeColor','r', 'EdgeAlpha',1);
    set(gca, 'fontsize',10, 'ygrid','on', 'gridalpha',1, 'yminorgrid','on', 'minorgridalpha',1)
    if length(edgesB) <= allow_ntcks
        set(gca, 'xtick',edgesB, 'xticklabel',round(edgesB*1000)/1000, 'xticklabelrotation',90)
    else
        set(gca, 'xtick',edgesB(1:ceil(length(edgesB)/allow_ntcks):length(edgesB)), 'xticklabel',round(edgesB(1:ceil(length(edgesB)/allow_ntcks):length(edgesB))*1000)/1000, 'xticklabelrotation',90)
    end
    box on
    legend('Files A', 'Files B', 'location','southeast')
    xlabel('time [s]', 'fontsize',12)
    ylabel('recurrence [per trial]', 'fontsize',12)
    title('Average No. of Segment Boundaries', 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 3)
    hold on
    histogram('BinEdges',edgesM, 'BinCounts',HMA, 'FaceColor','b', 'FaceAlpha',0.5, 'EdgeColor','b', 'EdgeAlpha',1);
    histogram('BinEdges',edgesM, 'BinCounts',HMB, 'FaceColor','r', 'FaceAlpha',0.5, 'EdgeColor','r', 'EdgeAlpha',1);
    set(gca, 'fontsize',10, 'ygrid','on', 'gridalpha',1, 'yminorgrid','on', 'minorgridalpha',1)
    if length(edgesM) <= allow_ntcks
        set(gca, 'xtick',edgesM, 'xticklabel',round(edgesM*1000)/1000, 'xticklabelrotation',90)
    else
        set(gca, 'xtick',edgesM(1:ceil(length(edgesM)/allow_ntcks):length(edgesM)), 'xticklabel',round(edgesM(1:ceil(length(edgesM)/allow_ntcks):length(edgesM))*1000)/1000, 'xticklabelrotation',90)
    end
    box on
    legend('Files A', 'Files B', 'location','southeast')
    xlabel('time [s]', 'fontsize',12)
    ylabel('recurrence [per trial]', 'fontsize',12)
    title('Average No. of Segment Midpoints', 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 2)
    hold on
    scatter(cell2mat(PropBoundA), cell2mat(PropLENA), 'b')
    scatter(cell2mat(PropBoundB), cell2mat(PropLENB), 'r')
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    legend('Files A', 'Files B')
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title(['Segment Length vs. Beginning Boundary',' (Bivar K-S Test p-value = ',num2str(bikspvalbound,'%1.2g'),')'], 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 4)
    hold on
    scatter(mean(BoundMatA,1), SEGLENA, 'b')
    scatter(mean(BoundMatB,1), SEGLENB, 'r')
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    legend('Files A', 'Files B')
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title(['Segment Length vs. Midpoint',' (Bivar K-S Test p-value = ',num2str(bikspvalmidp,'%1.2g'),')'], 'fontsize',12, 'fontweight','b')
    figure('name', 'Segmentation Statistics')
    set(gcf, 'windowstate','maximized');
    subplot(2, 2, 1);
    hold on
    plot(timesP, LENavA, 'b-', 'linewidth',2);
    plot(timesP, LENavB, 'r-', 'linewidth',2);
    fill([timesP;flipud(timesP)], [LENavA-LENsdA;flipud(LENavA+LENsdA)], 'b', 'facealpha',0.25, 'edgecolor','b', 'edgealpha',0.25)
    fill([timesP;flipud(timesP)], [LENavB-LENsdB;flipud(LENavB+LENsdB)], 'r', 'facealpha',0.25, 'edgecolor','r', 'edgealpha',0.25)
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    legend(['Files A: ','\mu = ',num2str(round(10*AVdynA)/10),', \sigma = ',num2str(round(10*SDdynA)/10),' [ms]'], ...
           ['Files B: ','\mu = ',num2str(round(10*AVdynB)/10),', \sigma = ',num2str(round(10*SDdynB)/10),' [ms]'])
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title(['Average Length of Encompassing Segment',' (correlation = ',num2str(PCORR,'%1.2g'),')'], 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 3)
    hold on
    HLA = histogram(SEGLENA, 'normalization','pdf', 'facecolor','b', 'facealpha',0.5, 'edgecolor','b', 'edgealpha',1, ...
          'displayname', ['Files A: histogram',' (Av = ',num2str(round(10*AVA)/10),', SD = ',num2str(round(10*SDA)/10),' [ms])']);
    try
        PDFA           = fitdist(SEGLENA', 'Burr');
        [~,pvalA,chiA] = chi2gof(SEGLENA', 'CDF',PDFA, 'Edges',HLA.BinEdges, 'EMin',0);
        plot(HLA.BinEdges(1):HLA.BinEdges(end), pdf(PDFA,HLA.BinEdges(1):HLA.BinEdges(end)), 'b-', 'linewidth',2, 'displayname',...
            ['Files A: Burr distribution\newline','c = ',num2str(round(100*PDFA.c)/100),', k = ',num2str(round(100*PDFA.k)/100),...
            ', \alpha = ',num2str(round(100*PDFA.alpha)/100),'\newline','\chi^2 test p-value = ',num2str(pvalA,'%1.2g')]);
    catch
        PDFA           = [];
    end
    HLB = histogram(SEGLENB, 'normalization','pdf', 'facecolor','r', 'facealpha',0.5, 'edgecolor','r', 'edgealpha',1, ...
          'displayname', ['Files B: histogram',' (Av = ',num2str(round(10*AVB)/10),', SD = ',num2str(round(10*SDB)/10),' [ms])']);
    try
        PDFB           = fitdist(SEGLENB', 'Burr');
        [~,pvalB,chiB] = chi2gof(SEGLENB', 'CDF',PDFB, 'Edges',HLB.BinEdges, 'EMin',0);
        plot(HLB.BinEdges(1):HLB.BinEdges(end), pdf(PDFB,HLB.BinEdges(1):HLB.BinEdges(end)), 'r-', 'linewidth',2, 'displayname',...
            ['Files B: Burr distribution\newline','c = ',num2str(round(100*PDFB.c)/100),', k = ',num2str(round(100*PDFB.k)/100),...
            ', \alpha = ',num2str(round(100*PDFB.alpha)/100),'\newline','\chi^2 test p-value = ',num2str(pvalB,'%1.2g')]);
    catch
        PDFB           = [];
    end
    legend('show')
    set(gca, 'fontsize',10, 'ygrid','on', 'gridalpha',1, 'yminorgrid','on', 'minorgridalpha',1)
    if length(HLA.BinEdges(1:ceil(length(HLA.BinEdges)/allow_ntcks):length(HLA.BinEdges))) >= length(HLB.BinEdges(1:ceil(length(HLB.BinEdges)/allow_ntcks):length(HLB.BinEdges)))
        set(gca, 'xtick',HLA.BinEdges(1:ceil(length(HLA.BinEdges)/allow_ntcks):length(HLA.BinEdges)), 'xticklabel',round(HLA.BinEdges(1:ceil(length(HLA.BinEdges)/allow_ntcks):length(HLA.BinEdges))), 'xticklabelrotation',90)
    else
        set(gca, 'xtick',HLB.BinEdges(1:ceil(length(HLB.BinEdges)/allow_ntcks):length(HLB.BinEdges)), 'xticklabel',round(HLB.BinEdges(1:ceil(length(HLB.BinEdges)/allow_ntcks):length(HLB.BinEdges))), 'xticklabelrotation',90)
    end
    box on
    xlabel('segment length [ms]', 'fontsize',12)
    ylabel('probability', 'fontsize',12)
    title(['PMF of Segment Lengths',' (K-S Test p-value = ',num2str(kspval,'%1.2g'),')'], 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 2)
    hold on
    scatter(MAXLENA(1,:), MAXLENA(2,:), 'b', 'LineWidth',2)
    scatter(MAXLENB(1,:), MAXLENB(2,:), 'r', 'LineWidth',2)
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    legend(['Files A:',' Av = ',num2str(round(10*AVmaxA)/10),', SD = ',num2str(round(10*SDmaxA)/10),' [ms]'], ['Files B:',' Av = ',num2str(round(10*AVmaxB)/10),', SD = ',num2str(round(10*SDmaxB)/10),' [ms]'])
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title('Maximum Segment Length vs. Beginning Boundary', 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 4)
    hold on
    scatter(MINLENA(1,:), MINLENA(2,:), 'b', 'LineWidth',2)
    scatter(MINLENB(1,:), MINLENB(2,:), 'r', 'LineWidth',2)
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    legend(['Files A:',' Av = ',num2str(round(10*AVminA)/10),', SD = ',num2str(round(10*SDminA)/10),' [ms]'], ['Files B:',' Av = ',num2str(round(10*AVminB)/10),', SD = ',num2str(round(10*SDminB)/10),' [ms]'])
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title('Minimum Segment Length vs. Beginning Boundary', 'fontsize',12, 'fontweight','b')
    if AvNxtBound
        figure('name', 'Segmentation Statistics')
        hold on
        plot(timesP, NXTavA, 'b-', 'linewidth',2);
        plot(timesP, NXTavB, 'r-', 'linewidth',2);
        fill([timesP;flipud(timesP)], [NXTavA-NXTsdA;flipud(NXTavA+NXTsdA)], 'b', 'facealpha',0.25, 'edgecolor','b', 'edgealpha',0.25)
        fill([timesP;flipud(timesP)], [NXTavB-NXTsdB;flipud(NXTavB+NXTsdB)], 'r', 'facealpha',0.25, 'edgecolor','r', 'edgealpha',0.25)
        set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
        legend('Files A', 'Files B')
        xlabel('time [s]', 'fontsize',12)
        ylabel('remaining duration [ms]', 'fontsize',12)
        title('Average duration until Encompassing Segment End', 'fontsize',12, 'fontweight','b')
        grid on
        box on
    end
    % Export statistics to file
    if ~isempty(StatFile)
        SegmentBoundaries.Begin.A         = BoundA(1,:);
        SegmentBoundaries.End.A           = BoundA(2,:);
        SegmentBoundaries.Begin.B         = BoundB(1,:);
        SegmentBoundaries.End.B           = BoundB(2,:);
        SegmentBoundaries.unit            = '[s]';
        HistSegmentBoundaries.BinEdges    = edgesB;
        HistSegmentBoundaries.BinCounts.A = HBA;
        HistSegmentBoundaries.BinCounts.B = HBB;
        HistSegmentBoundaries.BiKSpvalue  = bikspvalbound;
        HistSegmentMidPoints.BinEdges     = edgesM;
        HistSegmentMidPoints.BinCounts.A  = HMA;
        HistSegmentMidPoints.BinCounts.B  = HMB;
        HistSegmentMidPoints.BiKSpvalue   = bikspvalmidp;
        AllSegmentLengths.Lengths.A       = SEGLENA;
        AllSegmentLengths.Av.A            = AVA;
        AllSegmentLengths.SD.A            = SDA;
        AllSegmentLengths.Lengths.B       = SEGLENB;
        AllSegmentLengths.Av.B            = AVB;
        AllSegmentLengths.SD.B            = SDB;
        AllSegmentLengths.unit            = '[ms]';
        AllSegmentLengths.KSpvalue        = kspval;
        MaxSegmentLengths.time.A          = MAXLENA(1,:);
        MaxSegmentLengths.Lengths.A       = MAXLENA(2,:);
        MaxSegmentLengths.Av.A            = AVmaxA;
        MaxSegmentLengths.SD.A            = SDmaxA;
        MaxSegmentLengths.time.B          = MAXLENB(1,:);
        MaxSegmentLengths.Lengths.B       = MAXLENB(2,:);
        MaxSegmentLengths.Av.B            = AVmaxB;
        MaxSegmentLengths.SD.B            = SDmaxB;
        MaxSegmentLengths.unit          = '[ms]';
        MinSegmentLengths.time.A          = MINLENA(1,:);
        MinSegmentLengths.Lengths.A       = MINLENA(2,:);
        MinSegmentLengths.Av.A            = AVminA;
        MinSegmentLengths.SD.A            = SDminA;
        MinSegmentLengths.time.B          = MINLENB(1,:);
        MinSegmentLengths.Lengths.B       = MINLENB(2,:);
        MinSegmentLengths.Av.B            = AVminB;
        MinSegmentLengths.SD.B            = SDminB;
        MinSegmentLengths.unit          = '[ms]';
        DynamicSegmentLength.time         = timesP;
        DynamicSegmentLength.DynAv.A      = LENavA;
        DynamicSegmentLength.DynSD.A      = LENsdA;
        DynamicSegmentLength.mu.A         = AVdynA;
        DynamicSegmentLength.sigma.A      = SDdynA;
        DynamicSegmentLength.DynAv.B      = LENavB;
        DynamicSegmentLength.DynSD.B      = LENsdB;
        DynamicSegmentLength.mu.B         = AVdynB;
        DynamicSegmentLength.sigma.B      = SDdynB;
        DynamicSegmentLength.Pcorrelation = PCORR;
        DynamicDurationtoSegEnd.time      = timesP;
        DynamicDurationtoSegEnd.DynAv.A   = NXTavA;
        DynamicDurationtoSegEnd.DynSD.A   = NXTsdA;
        DynamicDurationtoSegEnd.DynAv.B   = NXTavB;
        DynamicDurationtoSegEnd.DynSD.B   = NXTsdB;
        HistSegmentLengths.BinEdges.A     = HLA.BinEdges;
        HistSegmentLengths.BinCounts.A    = HLA.Values;
        HistSegmentLengths.BinEdges.B     = HLB.BinEdges;
        HistSegmentLengths.BinCounts.B    = HLB.Values;
        if ~isempty(PDFA)
            HistSegmentLengths.PDF.A      = PDFA;
            HistSegmentLengths.pvalue.A   = pvalA;
            HistSegmentLengths.chi2.A     = chiA;
        end
        if ~isempty(PDFB)
            HistSegmentLengths.PDF.B      = PDFB;
            HistSegmentLengths.pvalue.B   = pvalB;
            HistSegmentLengths.chi2.B     = chiB;
        end
        save(StatFile, 'SegmentBoundaries', 'HistSegmentBoundaries', 'HistSegmentMidPoints', 'AllSegmentLengths', 'MaxSegmentLengths', 'MinSegmentLengths', 'DynamicSegmentLength', 'DynamicDurationtoSegEnd', 'HistSegmentLengths')
    end
end


%% ===== COMPUTE =====
function [SEGPNTS, INFO] = Compute(EEG, Wr, Wd, Ws, Wp, Wv, Domain, AvRemove, Band, srate, prgrss_factor, VoicesPOct)
    % [SEGPNTS, INFO] = Compute(EEG, Wr, Wd, Ws, Wp, Wv, Domain, AvRemove, Band, srate, prgrss_factor, VoicesPOct)

    % Source-informed segmentation.
    % EEG     = (nchan * T) EEG matrix with nchan channels and T time samples.
    % SEGPNTS = (1 * nsegs) segment beginning boundary indeces (always starting with 1).
    % INFO    = information structure,
    %           INFO.Wr       = Wr,
    %           INFO.Wd       = Wd,
    %           INFO.Ws       = Ws,
    %           INFO.Wp       = Wp,
    %           INFO.Wv       = Wv,
    %           INFO.unit     = '[sample]',
    %           INFO.Domain   = Domain,
    %           INFO.Band     = Band,
    %           INFO.AvRemove = AvRemove,
    %           INFO.svals    = (1 * nsegs) cell array with (1 * Rseg) significant singular values,
    %           INFO.svecs    = (1 * nsegs) cell array with (nchan * Rseg) significant left singular vectors,
    %           INFO.erat     = (1 * nsegs) ratios of energy within the significant left singular space,
    %           INFO.pval     = (1 * nsegs) p-values at detected segment boundaries,
    %           INFO.avsegs   = (nchan * nsegs) average EEG segments (columns),
    %           INFO.stdsegs  = (nchan * nsegs) standard deviation of EEG segments (columns).
    
    if ~isempty(Band)
        if (Band(1)>0) && (Band(2)<srate/2)
            EEG = bandpass(EEG.', Band, srate).';
        elseif Band(1) == 0
            EEG = lowpass(EEG.', Band(2), srate).';
        elseif Band(2) >= srate/2
            EEG = highpass(EEG.', Band(1), srate).';
        end
    end
    [nchan_e, T] = size(EEG);
    switch Domain
        case 'time'
            DAT = EEG;
        case 'frequency'
            fb  = cwtfilterbank('Wavelet','amor', 'SignalLength',T, 'SamplingFrequency',srate, 'FrequencyLimits',Band, 'VoicesPerOctave',VoicesPOct);
            DAT = cell(nchan_e, 1);
            for ch = 1:nchan_e
                DAT{ch} = cwt(EEG(ch,:), 'FilterBank',fb);
            end
            DAT = cell2mat(DAT);
        case 'phase'
            DAT = hilbert(EEG.').';
    end
    nchan         = size(DAT, 1);
    INFO.Wr       = Wr;
    INFO.Wd       = Wd;
    INFO.Ws       = Ws;
    INFO.Wp       = Wp;
    INFO.Wv       = Wv;
    INFO.unit     = '[sample]';
    INFO.Domain   = Domain;
    INFO.Band     = Band;
    INFO.AvRemove = AvRemove;
    INFO.svals    = {};
    INFO.svecs    = {};
    INFO.erat     = [];
    INFO.pval     = 0;
    segind        = 1;
    SEGPNTS       = 1;
    cursegsize    = Wr;
    while (SEGPNTS(segind)+cursegsize-1+Ws-Wv) <= T
        slidpnt = SEGPNTS(segind) + cursegsize - Wv;
        refwin  = DAT(:, SEGPNTS(segind):SEGPNTS(segind)+cursegsize-1);
        slidwin = DAT(:, slidpnt:slidpnt+Ws-1);
        if AvRemove && strcmp(Domain,'time')
            refwin  = refwin - mean(refwin,2);
            slidwin = slidwin - mean(slidwin,2);
        end
        if sum(abs(refwin(:))) == 0
            R  = 1;
            er = 1;
            Sr = 0;
            F  = ones(nchan,1) / sqrt(nchan);
        elseif strcmp(Domain, 'frequency')
            [Ur, Sr] = eigs(double(imag(refwin * refwin')), cursegsize);
            Sr       = sqrt(1i * imag(Sr));
            [sv, si] = sort(abs(diag(Sr)), 'descend');
            Sr       = Sr(si, si);
            Ur       = Ur(:, si);
            [R, er]  = Compute_elbow(sv(1:2:cursegsize));
            R        = 2 * R;
            F        = Ur(:, 1:R);
        else
            [Ur, Sr] = svd(refwin, 'econ');
            [R, er]  = Compute_elbow(diag(Sr));
            F        = Ur(:, 1:R);
        end
        Er           = sum(abs(refwin).^2,1) - sum(abs(F'*refwin).^2,1);
        Es           = sum(abs(slidwin).^2,1) - sum(abs(F'*slidwin).^2,1);
        [dcsn, pval] = kstest2(Er, Es);
        if dcsn
            dcsnnum     = 1;
            pv          = pval;
            slidpntminp = slidpnt;
            svals       = diag(Sr(1:R,1:R));
            svecs       = F;
            erat        = er;
            while ((pv<pval)||(dcsnnum<Wd)||(dcsnnum==1)) && dcsn
                if pv < pval
                    pval        = pv;
                    slidpntminp = slidpnt;
                    svals       = diag(Sr(1:R,1:R));
                    svecs       = F;
                    erat        = er;
                end
                cursegsize = cursegsize + Wp;
                slidpnt    = SEGPNTS(segind) + cursegsize - Wv;
                if (SEGPNTS(segind)+cursegsize-1+Ws-Wv) <= T
                    refwin  = DAT(:,SEGPNTS(segind):SEGPNTS(segind)+cursegsize-1);
                    slidwin = DAT(:,slidpnt:slidpnt+Ws-1);
                    if AvRemove && strcmp(Domain,'time')
                        refwin  = refwin - mean(refwin,2);
                        slidwin = slidwin - mean(slidwin,2);
                    end
                    if sum(abs(refwin(:))) == 0
                        R  = 1;
                        er = 1;
                        Sr = 0;
                        F  = ones(nchan,1) / sqrt(nchan);
                    elseif strcmp(Domain, 'frequency')
                        [Ur, Sr] = eigs(double(imag(refwin * refwin')), cursegsize);
                        Sr       = sqrt(1i * imag(Sr));
                        [sv, si] = sort(abs(diag(Sr)), 'descend');
                        Sr       = Sr(si, si);
                        Ur       = Ur(:, si);
                        [R, er]  = Compute_elbow(sv(1:2:cursegsize));
                        R        = 2 * R;
                        F        = Ur(:, 1:R);
                    else
                        [Ur, Sr] = svd(refwin, 'econ');
                        [R, er]  = Compute_elbow(diag(Sr));
                        F        = Ur(:, 1:R);
                    end
                    Er         = sum(abs(refwin).^2,1) - sum(abs(F'*refwin).^2,1);
                    Es         = sum(abs(slidwin).^2,1) - sum(abs(F'*slidwin).^2,1);
                    [dcsn, pv] = kstest2(Er, Es);
                    if dcsn
                        dcsnnum = dcsnnum + 1;
                    end
                else
                    break
                end
            end
            if dcsnnum >= Wd
                INFO.svals{segind}  = svals.';
                INFO.svecs{segind}  = svecs;
                INFO.erat(segind)   = erat;
                INFO.pval(segind+1) = pval;
                segind              = segind + 1;
                SEGPNTS(segind)     = slidpntminp; %#ok<AGROW>
                cursegsize          = Wr;
                bst_progress('set', round(100*(prgrss_factor(1)+(SEGPNTS(segind)/T))/prgrss_factor(2)));
            else
                cursegsize = cursegsize + Wp;
            end
        else
            cursegsize = cursegsize + Wp;
        end
    end
    refwin = DAT(:, SEGPNTS(segind):T);
    if AvRemove && strcmp(Domain,'time')
        refwin = refwin - mean(refwin,2);
    end
    if sum(abs(refwin(:))) == 0
        INFO.svals{segind} = 0;
        INFO.svecs{segind} = ones(nchan,1) / sqrt(nchan);
        INFO.erat(segind)  = 1;
    elseif strcmp(Domain, 'frequency')
        [Ur, Sr]           = eigs(double(imag(refwin * refwin')), T-SEGPNTS(segind)+1);
        Sr                 = sqrt(1i * imag(Sr));
        [sv, si]           = sort(abs(diag(Sr)), 'descend');
        Sr                 = Sr(si, si);
        Ur                 = Ur(:, si);
        [R, er]            = Compute_elbow(sv(1:2:T-SEGPNTS(segind)+1));
        R                  = 2 * R;
        INFO.svals{segind} = diag(Sr(1:R, 1:R)).';
        INFO.svecs{segind} = Ur(:, 1:R);
        INFO.erat(segind)  = er;
    else
        [Ur, Sr]           = svd(refwin, 'econ');
        [R, er]            = Compute_elbow(diag(Sr));
        INFO.svals{segind} = diag(Sr(1:R, 1:R)).';
        INFO.svecs{segind} = Ur(:, 1:R);
        INFO.erat(segind)  = er;
    end
    augsegpnts   = [SEGPNTS, T+1];
    INFO.avsegs  = zeros(nchan_e, segind);
    INFO.stdsegs = zeros(nchan_e, segind);
    for seg = 1:segind
        INFO.avsegs(:, seg)  = mean(EEG(:,augsegpnts(seg):augsegpnts(seg+1)-1), 2);
        INFO.stdsegs(:, seg) = std(EEG(:,augsegpnts(seg):augsegpnts(seg+1)-1), 0, 2);
    end
    bst_progress('set', round(100*(prgrss_factor(1)+1)/prgrss_factor(2)));
end


%% ===== COMPUTE_ELBOW =====
function [ind, erat] = Compute_elbow(x)
    %  [ind, erat] = Compute_elbow(x)

    % Curve elbowing.
    % x    = length N vector.
    % ind  = index of the sample before the elbow.
    % erat = ratio of energy in the curve down to ind.

    N        = length(x);
    dx       = x(1:N-2) -2*x(2:N-1) + x(3:N);
    [~, ind] = max(dx);
    erat     = x(1:ind)'*x(1:ind) / (x'*x);
end


%% ===== COMPUTE_BIKSTEST2 =====
function [H, pValue, KSstatistic] = Compute_bikstest2(XY1, XY2)
% [H, pValue, KSstatistic] = Compute_bikstest2(XY1, XY2)

alpha = 0.05;
n1    = size(XY1, 1);
n2    = size(XY2, 1);
for j = 1:n1
   [fa, fb, fc, fd] = Compute_quadct(XY1(j,:), XY1, n1);
   [ga, gb, gc, gd] = Compute_quadct(XY1(j,:), XY2, n2);
   d1               = max(abs([fa-ga, fb-gb, fc-gc, fd-gd]));
end
for j = 1:n2
   [fa, fb, fc, fd] = Compute_quadct(XY2(j,:), XY1, n1);
   [ga, gb, gc, gd] = Compute_quadct(XY2(j,:), XY2, n2);
   d2               = max(abs([fa-ga, fb-gb, fc-gc, fd-gd]));
end
KSstatistic = (d1+d2) / 2;
sqen        = sqrt(n1 * n2 / (n1+n2));
r1          = Compute_pearsn(XY1);
r2          = Compute_pearsn(XY2);
rr          = sqrt(1 - ((r1^2+r2^2)/2));
pValue      = Compute_probks(KSstatistic * sqen / (1+rr*(0.25-0.75/sqen)));
H           = pValue <= alpha;
end


%% ===== COMPUTE_QUADCT =====
function [fa, fb, fc, fd] = Compute_quadct(xy, XY, nn)
% [fa, fb, fc, fd] = Compute_quadct(xy, XY, nn)

xrght = XY(:,1) > xy(1);
xleft = XY(:,1) < xy(1);
yrght = XY(:,2) > xy(2);
yleft = XY(:,2) < xy(2);
na    = and(xrght, yrght);
nb    = and(xleft, yrght);
nc    = and(xleft, yleft);
nd    = and(xrght, yleft);
fa    = sum(na) / nn;
fb    = sum(nb) / nn;
fc    = sum(nc) / nn;
fd    = sum(nd) / nn;
end


%% ===== COMPUTE_PROBKS =====
function prb = Compute_probks(alam)
% prb = Compute_probks(alam)

eps1 = 0.001;
eps2 = 1e-8;
a2   = -2 * alam^2;
j    = (1:100)';
fac  = -2 * (-1).^j;
term = fac .* exp(a2*j.^2);
sm   = sum(term);
if (abs(term(100))<=(eps1*abs(term(99)))) || (abs(term(100))<=(eps2*sm))
    prb = sm;
else
    prb = 1;
end
end


%% ===== COMPUTE_PEARSN =====
function r = Compute_pearsn(XY)
% r = Compute_pearsn(XY)

tiny = 1e-20;
xt   = XY(:,1) - mean(XY(:,1));
yt   = XY(:,2) - mean(XY(:,2));
r    = (xt'*yt) / (sqrt((xt'*xt)*(yt'*yt))+tiny);
end
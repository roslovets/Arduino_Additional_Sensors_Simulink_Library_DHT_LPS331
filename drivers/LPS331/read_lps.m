classdef read_lps < realtime.internal.SourceSampleTime ...
        & coder.ExternalDependency ...
        & matlab.system.mixin.Propagates ...
        & matlab.system.mixin.CustomIcon
    %
    % LPS331 barometer driver for Arduino based on System Object.
    % 
    % Driver based on Pololu LPS331 Library 
    % https://github.com/pololu/lps331-arduino
    % Also driver include Arduino Wire Library to work with I2C
    %#codegen
    %#ok<*EMCA>
    
    properties
        Imp = false;
    end
    
    properties (Nontunable)
        % Public, non-tunable properties.
    end
    
    properties (Access = private)
        % Pre-computed constants.
    end
    
    methods
        % Constructor
        function obj = read_lps(varargin)
            % Support name-value pair arguments when constructing the object.
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    
    methods (Access=protected)
        function setupImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Place simulation setup code here
            else
                coder.cinclude('lps331_arduino.h');
                coder.ceval('setLPS');
            end
        end
        
        function [P, Alt, T] = stepImpl(obj)   %#ok<MANU>
            P = single(0);
            Alt = single(0);
            T = single(0);
            if isempty(coder.target)
                % Place simulation output code here
            else
                % Call C-function implementing device output
                if obj.Imp
                    P = coder.ceval('readPressureInchesHg');
                    Alt = coder.ceval('pressureToAltitudeFeet', P);
                    T = coder.ceval('readTemperatureF');
                else
                    P = coder.ceval('readPressureMillibars');
                    Alt = coder.ceval('pressureToAltitudeMeters', P);
                    T = coder.ceval('readTemperatureC');
                end
            end
        end
        
        function releaseImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Place simulation termination code here
            else
                % Call C-function implementing device termination
                %coder.ceval('source_terminate');
            end
        end
    end
    
    methods (Access=protected)
        %% Define output properties
        function num = getNumInputsImpl(~)
            num = 0;
        end
        
        function num = getNumOutputsImpl(~)
            num = 3;
        end
        
        function flag = isOutputSizeLockedImpl(~,~)
            flag = true;
        end
        
        function varargout = isOutputFixedSizeImpl(~,~)
            varargout = {true, true, true};
        end
        
        function flag = isOutputComplexityLockedImpl(~,~)
            flag = true;
        end
        
        function varargout = isOutputComplexImpl(~)
            varargout = {false, false, false};
        end
        
        function varargout = getOutputSizeImpl(~)
            varargout = {[1,1], [1,1], [1,1]};
        end
        
        function varargout = getOutputDataTypeImpl(~)
            varargout = {'single', 'single', 'single'};
        end
        
        function icon = getIconImpl(~)
            % Define a string as the icon for the System block in Simulink.
            icon = 'read_lps';
        end    
    end
    
    methods (Static, Access=protected)
        function simMode = getSimulateUsingImpl(~)
            simMode = 'Interpreted execution';
        end
        
        function isVisible = showSimulateUsingImpl
            isVisible = false;
        end
    end
    
    methods (Static)
        function name = getDescriptiveName()
            name = 'Source';
        end
        
        function b = isSupportedContext(context)
            b = context.isCodeGenTarget('rtw');
        end
        
        function updateBuildInfo(buildInfo, context)
            if context.isCodeGenTarget('rtw')
                % Update buildInfo
                srcDir = fullfile(fileparts(mfilename('fullpath')),'src'); %#ok<NASGU>
                includeDir = fullfile(fileparts(mfilename('fullpath')),'include');
                addIncludePaths(buildInfo,includeDir);
                % Use the following API's to add include files, sources and
                % linker flags
                addSourceFiles(buildInfo,'lps331_arduino.cpp', srcDir);
                addSourceFiles(buildInfo,'LPS331.cpp', includeDir);
                addSourceFiles(buildInfo,'Wire.cpp', includeDir);
                addSourceFiles(buildInfo,'twi.c', [includeDir '\utility']);
                %addIncludeFiles(buildInfo,'source.h',includeDir);
                %addSourceFiles(buildInfo,'source.c',srcDir);
                %addLinkFlags(buildInfo,{'-lSource'});
                %addLinkObjects(buildInfo,'sourcelib.a',srcDir);
                %addCompileFlags(buildInfo,{'-D_DEBUG=1'});
                %addDefines(buildInfo,'MY_DEFINE_1')
            end
        end
    end
end

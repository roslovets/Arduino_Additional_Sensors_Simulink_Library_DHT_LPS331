classdef read_dht < realtime.internal.SourceSampleTime ...
        & coder.ExternalDependency ...
        & matlab.system.mixin.Propagates ...
        & matlab.system.mixin.CustomIcon
    %
    % DHT temperature-humidity sensor driver for Arduino based on System Object.
    % 
    % Driver based on Adafruit DHT Library 
    % https://github.com/adafruit/DHT-sensor-library
    % Works with DHT11 (tested) and also might work with DHT22, DHT21, AM2301 (not tested!)
    %#codegen
    %#ok<*EMCA>
    
    properties
        % Pin_num
        Pin = 8;
        % Sensor_type
        Sensor = 11;
        % Read_in_Fahrenheit
        F = false;
    end
    
    properties (Nontunable)
        % Nontunable options.
    end
    
    properties (Access = private)
        % Pre-computed constants.
    end
    
    methods
        % Constructor
        function obj = read_dht(varargin)
            % Support name-value pair arguments when constructing the object.
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    
    methods (Access=protected)
        function setupImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Place simulation setup code here
            else
                % Call C-function implementing device initialization
                coder.cinclude('dht_arduino.h');
                coder.ceval('setDHT', uint8(obj.Pin), uint8(obj.Sensor));
            end
        end
        
        function [H, T, HI] = stepImpl(obj)   %#ok<MANU>
            H = single(0);
            T = single(0);
            HI = single(0);
            if isempty(coder.target)
                % Place simulation output code here
            else
                % Call C-function implementing device output
                H = coder.ceval('readHumidity');
                if obj.F % if in Fahrenheit
                    T = coder.ceval('readTempF');
                    HI = coder.ceval('computeHeatIndexF', T, H);
                else % if in Celsius
                    T = coder.ceval('readTemp');
                    HI = coder.ceval('computeHeatIndex', T, H);
                end
            end
        end
        
        function releaseImpl(obj) %#ok<MANU>
            if isempty(coder.target)
                % Place simulation termination code here
            else
                % Call C-function implementing device termination
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
            icon = 'read_dht';
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
                addSourceFiles(buildInfo,'dht_arduino.cpp', srcDir);
                addSourceFiles(buildInfo,'Dht.cpp', includeDir);
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

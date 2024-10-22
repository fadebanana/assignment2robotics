classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        drawButton                   matlab.ui.control.Button
        startdrawingwithdobotButton  matlab.ui.control.Button
        resetthedataButton           matlab.ui.control.Button
        plzstarturdrawingLabel       matlab.ui.control.Label
        safteystopButton             matlab.ui.control.Button
        
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: drawButton
        function drawButtonPushed(app, event)
           ax = axes('Parent', uifigure);

           F=drawfreehand(ax);
           F.Position
           disp F.Position; 
           filename = 'testdata.mat';
           save(filename)
           return 
        end
         % Button pushed function: startdrawingwithdobotButton
        function DobotDraw(app, event)
            return
        end

         % Button pushed function: stop
        function stop(app, event)
            uiwait; 
            disp ('emergency stop ')
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';
            
            % Create drawButton
            app.drawButton = uibutton(app.UIFigure, 'push');
            app.drawButton.ButtonPushedFcn = createCallbackFcn(app, @drawButtonPushed, true);
            app.drawButton.Position = [26 25 200 233];
            app.drawButton.Text = {'draw'; ''};

            % Create startdrawingwithdobotButton
            app.startdrawingwithdobotButton = uibutton(app.UIFigure, 'push');
            app.startdrawingwithdobotButton.ButtonPushedFcn = createCallbackFcn(app, @DobotDraw, true);
            app.startdrawingwithdobotButton.Position = [397 25 208 233];
            app.startdrawingwithdobotButton.Text = 'start drawing with dobot';

            % Create resetthedataButton
            app.resetthedataButton = uibutton(app.UIFigure, 'push');
            app.resetthedataButton.Position = [266 92 89 82];
            app.resetthedataButton.Text = 'reset the data';

            % Create plzstarturdrawingLabel
            app.plzstarturdrawingLabel = uilabel(app.UIFigure);
            app.plzstarturdrawingLabel.HorizontalAlignment = 'center';
            app.plzstarturdrawingLabel.FontSize = 20;
            app.plzstarturdrawingLabel.FontWeight = 'bold';
            app.plzstarturdrawingLabel.Position = [152 423 318 58];
            app.plzstarturdrawingLabel.Text = 'plz start ur drawing';

            % Create safteystopButton
            app.safteystopButton = uibutton(app.UIFigure, 'push');
            app.startdrawingwithdobotButton.ButtonPushedFcn = createCallbackFcn(app, @stop, true);
            app.safteystopButton.Position = [469 344 128 59];
            app.safteystopButton.Text = 'saftey stop';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
% kitt

L = 8;
PWM_LEN = 100;
pwm = zeros(L,PWM_LEN);
pwm_stream = zeros(1,PWM_LEN);
STEP = 0.25;
MINIMUM = 0.00;
MAXIMUM = 0.8;
% PWM_SHAPE = polyval(polyfit([1,floor(PWM_LEN/4), floor(PWM_LEN/2),PWM_LEN],[1,floor(PWM_LEN/2),floor(PWM_LEN/1.4),PWM_LEN],3),1:PWM_LEN+10);
% plot(PWM_SHAPE);
% %

leds = zeros(L,1);
delta = zeros(L,1);
delta(end)=1.25;

speed = 50; % PWM repetition. lower number -> higher speed

total_repetition = 10;

for z = 1:total_repetition
    delta = zeros(L,1);
    delta(end)=1 +STEP;
    
    for i=1:L
        delta = circshift(delta,1);
        leds = min(leds + delta,MAXIMUM+STEP);
        % reduce leds
        leds = max(leds - STEP, MINIMUM);
        fprintf('%3.1f ',leds');
        fprintf('\n');
        % reorder leds to fit the usb-noc board
        leds_reordered = leds([5 3 4 7 2 8 6 1]);
        for j=1:L
            k = round(leds_reordered(j)*PWM_LEN);
%             if k > 0
%                 k = round(PWM_SHAPE(k));
%                 k = max(min(k,PWM_LEN),0);
%             end
            pwm(j,:) = [ones(1,k) zeros(1,PWM_LEN-k)];
        end
        pwm_stream = bin2dec(num2str(pwm'));
        for j = 1:speed
            usb_noc(pwm_stream);
        end
    end
    
    delta = zeros(L,1);
    delta(1)=1+STEP;
    
    for i=1:L
        delta = circshift(delta,-1);
        leds = min(leds + delta,MAXIMUM+STEP);
        % reduce leds
        leds = max(leds - STEP,MINIMUM);
        fprintf('%3.1f ',leds');
        fprintf('\n');
        % reorder leds to fit the usb-noc board
        leds_reordered = leds([5 3 4 7 2 8 6 1]);
        for j=1:L
            k = round(leds_reordered(j)*PWM_LEN);
%             if k > 0
%                 k = round(PWM_SHAPE(k));
%                 k = max(min(k,PWM_LEN),0);
%             end
            pwm(j,:) = [ones(1,k) zeros(1,PWM_LEN-k)];
        end
        pwm_stream = bin2dec(num2str(pwm'));
        for j = 1:speed
            usb_noc(pwm_stream);
        end
    end
    
    
end

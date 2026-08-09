 function [u_prbs, u_total] = generar_PRBS_para_identificacion(TTF, N, Amp, u_min, u_max)
    % Genera señal PRBS optimizada para identificación de sistemas
    % N: número de muestras
    % Amp: amplitud de la PRBS
    % u_min, u_max: límites de la señal
    % u_offset: punto de operación (offset)
    
    % 1. Configurar PRBS
    % Polinomio: x^7 + x^6 + 1 (periodo 127)
    seed = [1 0 0 0 0 0 0 1 1 0 0 1];
    reg = zeros(1, N);
    u_prbs = zeros(1, N);
    secuencia = [50, 90, 70, 30, 10, 20, 40, 60, 80]; %para niveles del PRBS
    % 2. Generar PRBS
    N_ts=N;
    sec_i = 0;
    for k = 1:N_ts
       if mod(k, TTF) == 0  % Cambiar en k=1,4,7,10,...
        %prbs9
%         bit = xor(seed(9), seed(5));
%         reg(k) = seed(9);  % Guardar valor actual
%         seed = [bit seed(1:8)];  % Desplazar registro
        %prbs12
        bit1 = xor(seed(12), seed(11));
        bit2 = xor(seed(8), seed(6)); % bits del polinomio (taps)
        bit = xor(bit1, bit2);
        reg(k) = seed(12); %crea el registro de secuencia de salida
        seed=[bit, seed(1:11)]; %desplazamiento del registro
       end
       
        % Mapear a [-Amp, Amp]
        u_prbs(k) = 2*Amp*reg(k) - Amp;
         if mod(k,14)==0 || k==1
          sec_i = sec_i+1;
           if sec_i>length(secuencia);
              sec_i = 1;
           end
         end
         % 4. Añadir offset
%          c = N/2;
%          if k>c
            offset = secuencia(sec_i);
            u_total(k) = u_prbs(k)+35;
%          else
%             u_total(k) = u_prbs(k)+70; %+offset;  
%          end
    end
    
    % 3. Asegurar que la PRBS esté en el rango permitido
    % Si Amp es muy grande, escalar
    if max(abs(u_prbs)) > max(abs(u_min), abs(u_max))
        scale = max(abs(u_prbs)) / max(abs(u_min), abs(u_max));
        u_prbs = u_prbs / scale;
        fprintf('?? PRBS escalada por factor %.2f\n', scale);
    end
    
   
    
    % 5. Saturar
    u_total = max(u_min, min(u_max, u_total));
    sec_o=sec_i;
    
%     % 6. Verificar calidad
    fprintf('=== ESTADÍSTICAS DE LA SEÑAL PRBS ===\n');
    fprintf('Rango de u_prbs: [%.2f, %.2f]\n', min(u_prbs), max(u_prbs));
    fprintf('Rango de u_total: [%.2f, %.2f]\n', min(u_total), max(u_total));
    fprintf('Media de u_total: %.2f\n', mean(u_total));
    fprintf('Desviación de u_total: %.2f\n', std(u_total));
% %     
%     % 7. Graficar
%     figure;
%     subplot(3,1,1);
%     plot(u_prbs(1:500));
%     title('PRBS pura (primeras 500 muestras)');
%     ylabel('Amplitud');
%     grid on;
%     
%     subplot(3,1,2);
%     plot(u_total(1:500));
%     title('PRBS con offset');
%     ylabel('Amplitud');
%     grid on;
%     
%     subplot(3,1,3);
%     histogram(u_total, 50);
%     title('Histograma de la señal');
%     xlabel('Amplitud');
%     ylabel('Frecuencia');
%     grid on;
end



  function [H] = SVD(H_z)

    % Obtener dimensiones
    [diM, diN] = size(H_z);
    min_dim = min(diM, diN);

    % Preasignar matrices truncadas
    U_trunc = zeros(diM, min_dim);
    S_trunc = zeros(min_dim, min_dim);
    V_trunc = zeros(diN, min_dim);

    % Preasignar matrices SVD
    U = zeros(diM, min_dim);
    S = zeros(min_dim, min_dim);
    V = zeros(diN, min_dim);

    % Preasignar vectores
    sigma = zeros(min_dim,1);
    sigma_norm = zeros(min_dim,1);

    % SVD económica
    [U,S,V] = svd(H_z,'econ');

    sigma = diag(S);
    % Evitar división por cero
    if sigma(1) <= eps
        H = H_z;
        return;
    end

    % Normalizar valores singulares
    sigma_norm = sigma ./ sigma(1);

    % Umbral
    umbral = 1e-4;

    % Por defecto conservar todos
    n_efectivo = length(sigma);

    % Buscar el primer valor singular pequeño
    for k = 1:length(sigma_norm)
        if sigma_norm(k) < umbral
            n_efectivo = k - 1;

            % Asegurar al menos un modo
            if n_efectivo < 1
                n_efectivo = 1;
            end

            break;
        end
    end

    % Truncar
    U_trunc = U(:,1:n_efectivo);
    S_trunc = S(1:n_efectivo,1:n_efectivo);
    V_trunc = V(:,1:n_efectivo);

    % Reconstrucción
    H = U_trunc*S_trunc*V_trunc';
    
  end
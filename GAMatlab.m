% GA.m

clear all
clc
global EFFI

popsize = 10;

% variar o angulo alfa para descobrir 
% Definindo os limites para os parâmetros [t, m, p] - 
lb = [0.01, 0.01, 0.01];
ub = [0.4, 0.095, 0.9];


% Gerando uma população inicial dentro dos limites lb e ub - 0012
initialpop = repmat([0.12, 0, 0], popsize, 1);

% Definindo a função objetivo
fun = @effnaca;

% Definindo as opções do GA
options = optimoptions('ga', 'PopulationSize', popsize, 'MaxGenerations', 30, 'InitialPopulation', initialpop);

% Chamando a função de otimização GA
[x, fval, exitflag, output, population, scores] = ga(fun, 3, [], [], [], [], lb, ub, [], options);

% Salvando os parâmetros iniciais do primeiro aerofólio gerado
t_inicial = initialpop(popsize, 1);
m_inicial = initialpop(popsize, 2);
p_inicial = initialpop(popsize, 3);

params_inicial = [t_inicial, m_inicial, p_inicial];

% Calculando a eficiência do primeiro aerofólio
eff_inicial = 1 / effnaca(params_inicial);

% Calculando o ganho em porcentagem em relação ao otimizado
ganho_percentual = abs(((- eff_inicial + 1/fval) / (1/fval)) * 100);

% Exibindo os resultados
disp(' ');
disp('Resultado da otimização:');
disp(['Parâmetros iniciais (t, m, p): ', num2str(t_inicial), ', ', num2str(m_inicial), ', ', num2str(p_inicial)]);
disp(['Parâmetros otimizados (t, m, p): ', num2str(x)]);
disp(['Eficiência do primeiro aerofólio: ', num2str(eff_inicial)]);
disp(['Eficiência aerodinâmica otimizada: ', num2str(1/fval)]);
disp(['Ganho em porcentagem em relação ao otimizado: ', num2str(ganho_percentual), '%']);

% Parâmetros otimizados (t, m, p)
t_optimizado = x(1);
m_optimizado = x(2);
p_optimizado = x(3);

% Configuração da estrutura iaf para o aerofólio inicial
iaf.t = num2str(t_inicial);
iaf.m = num2str(m_inicial);
iaf.p = num2str(p_inicial);
iaf.n = 25;
iaf.HalfCosineSpacing = 1;
iaf.wantFile = 0;
iaf.datFilePath = './'; % Pasta atual
iaf.is_finiteTE = 1; % Adicione esta linha para corrigir o erro
af_inicial = naca4gen(iaf);
X_inicial = af_inicial.x;
Y_inicial = af_inicial.z;

% Configuração da estrutura iaf para o aerofólio otimizado
iaf.t = num2str(t_optimizado);
iaf.m = num2str(m_optimizado);
iaf.p = num2str(p_optimizado);
iaf.is_finiteTE = 1; % Certifique-se de definir o campo para o aerofólio otimizado também
af_otimizado = naca4gen(iaf);
X_otimizado = af_otimizado.x;
Y_otimizado = af_otimizado.z;

% Plotando os aerofólios
figure;
plot(X_inicial, Y_inicial, 'b-', 'LineWidth', 2); % Linha azul para o aerofólio inicial
hold on;
plot(X_otimizado, Y_otimizado, 'r-', 'LineWidth', 2); % Linha vermelha para o aerofólio otimizado

% Configurando o gráfico
axis equal;
xlim([0 1]);
ylim([-0.2 0.3]);
title('Comparação entre Aerofólios Inicial e Otimizado');
xlabel('Posição ao longo da corda');
ylabel('Espessura do aerofólio');

% Adicionando legendas
legend('Aerofólio Inicial', 'Aerofólio Otimizado');

% Exibindo o gráfico
hold off;

scheme = "C:\Users\berto\OneDrive\Documents\Linkedin\LinkedinContentCode\linkedincontentcode\FF tuning\FF tuning.zcos";

// Simulate first
importXcosDiagram(scheme);

// Plot integral error function of kff

kff = [0:0.1:1.5];
iae = [];

for idx = 1:length(kff)
    ctx = ["m = 10; k = 0.5; kp = 1.3; ki = 0.05; kff = " + string(kff(idx)) "; std_noise = 0.5; T = 0.1; T_c = 1;"];
    scs_m.props.context = ctx;
    xcos_simulate(scs_m, 4);
    iae = [iae iae_out.values($)];
end

plot(kff, iae, 'ro', 'LineWidth',4);
set(gca(),"grid",[1 1]);
xlabel('kff', 'font_style', 'times bold', 'font_size', 4);
ylabel('Integral Absolute Error', 'font_style', 'times bold', 'font_size', 4);

// Simulate no FF (kff = 0)

ctx = ["m = 10; k = 0.5; kp = 1.3; ki = 0.05; kff = 0; std_noise = 0.5; T = 0.1; T_c = 1;"];
scs_m.props.context = ctx;
xcos_simulate(scs_m, 4);

u_no_FF = u_out;
v_no_FF = v_out;

// Simulate classic FF (kff = -1)

ctx = ["m = 10; k = 0.5; kp = 1.3; ki = 0.05; kff = 1; std_noise = 0.5; T = 0.1; T_c = 1;"];
scs_m.props.context = ctx;
xcos_simulate(scs_m, 4);

u_FF = u_out;
v_FF = v_out;

// Simulate tuned FF (kff = -0.8)

ctx = ["m = 10; k = 0.5; kp = 1.3; ki = 0.05; kff = 0.8; std_noise = 0.5; T = 0.1; T_c = 1;"];
scs_m.props.context = ctx;
xcos_simulate(scs_m, 4);

u_tuned_FF = u_out;
v_tuned_FF = v_out;

// Draw
subplot(212);
h = plot(u_no_FF.time, u_no_FF.values, 'b-', u_FF.time, u_FF.values, 'k-', u_tuned_FF.time, u_tuned_FF.values, 'r-', 'LineWidth',4);
l = legend("kff = 0", "kff = 1", "kff = 0.8");
l.font_size = 3;
ax=gca(),// gat the handle on the current axes
ax.data_bounds=[0 -200;150 80];
set(gca(),"grid",[1 1]);
xlabel('t[s]', 'font_style', 'times bold', 'font_size', 4);
ylabel('Control command [N]', 'font_style', 'times bold', 'font_size', 4);

subplot(211);
h = plot(stp_out.time, stp_out.values, 'g-', v_no_FF.time, v_no_FF.values, 'b-', v_FF.time, v_FF.values, 'k-', v_tuned_FF.time, v_tuned_FF.values, 'r-', 'LineWidth',4);
l = legend("Setpoint", "Response - kff = 0", "Response - kff = 1", "Response - kff = 0.8");
l.font_size = 3;
ax=gca(),// gat the handle on the current axes
ax.data_bounds=[0 -10;150 100];
set(gca(),"grid",[1 1]);
xlabel('t[s]', 'font_style', 'times bold', 'font_size', 4);
ylabel('Speed [m/s]', 'font_style', 'times bold', 'font_size', 4);

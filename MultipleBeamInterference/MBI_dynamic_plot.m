function MBI_dynamic_plot(MBI_plot_struct)

%default to full-screen
scrsz = get(0,'ScreenSize');
h=figure;
set(h,'position',scrsz);
for n=1:length(MBI_plot_struct.t)
    subplot(1,2,1)
    plot(MBI_plot_struct.y.*10^3,real(MBI_plot_struct.E0_MBI(:,n)./MBI_plot_struct.sum_E0),'b-','linewidth',1.1)
    xlabel('Distance in coverslip (mm)');ylabel('Electric Field (AU)')
    xlim(10.^3.*[min(MBI_plot_struct.y) max(MBI_plot_struct.y)]); ylim([min(min(real(MBI_plot_struct.E0_MBI)))./MBI_plot_struct.sum_E0 max(max(real(MBI_plot_struct.E0_MBI)))./MBI_plot_struct.sum_E0])
    title(sprintf('Time = %f ps',MBI_plot_struct.t(n).*10^12))
    axis square    
    
    subplot(1,2,2)
    var = 0 : .01 : 2 * pi;
    P = polar(var, max(max(abs(MBI_plot_struct.E0_MBI)./MBI_plot_struct.sum_E0)).*ones(size(var)));
    set(P, 'Visible', 'off')
    hold on
    P1=polar(angle(MBI_plot_struct.E0_MBI(:,n)),abs(MBI_plot_struct.E0_MBI(:,n)./MBI_plot_struct.sum_E0),'k-');
    title('Complex Electric Field')
    set(P1,'linewidth',1.1)
    hold off   

    pause(0.1)  

    if ishandle(h)==0 %if plot is prematurely closed, exit code.
        close all
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function plot_ultra(paras)
%   plot ultrasound signal levels for different locations of lasers  
%   input: paras
%         
%   author: jingjing Jiang jjiang@student.ethz.ch
%   created: 01.02.2016
%   modified: 27.12.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_ultra(paras)
cla
%-------------------- parameter assignment --------------------------%
a=paras.a;
ac_HHb_bulk = a* paras.CHHb; % * 100
ac_OHb_bulk = a* paras.COHb;
ac_H2O_bulk = a* paras.CH2O;
ac_Lipid_bulk = a* paras.CLipid;
oxy=paras.StOv;
b=paras.b;
vessel.r = paras.vesselpos(1,1);
vessel.z = paras.vesselpos(1,2);
laser1.r = paras.laserpos(1,1);
laser1.z = paras.laserpos(1,2);
num_lasers = paras.numLasers;
alllasers_r = laser1.r;

if num_lasers > 1
    laser2.r = paras.laserpos(2,1);
    laser2.z = paras.laserpos(2,1);
    alllasers_r = linspace(laser1.r, laser2.r, num_lasers);
end  
%-------------------- parameter assignment END--------------------------%
%------------------ calculate ultrasound signal level ------------------%
num_wav = 27;
wav = linspace(650,910,num_wav);
 
mus_bulk_noa = (wav / 1000).^(-b);

for ii = 1:num_wav
    mua_vessel(ii) = get_mua_vessel(oxy, wav(ii));
    mua_bulk_witha(ii) = get_mua_bulk(ac_HHb_bulk, ac_OHb_bulk, ...
        ac_H2O_bulk, ac_Lipid_bulk, wav(ii));
    mu_eff_bulk(ii) = sqrt(3* mua_bulk_witha(ii)* mus_bulk_noa(ii));
end

for jj = 1: num_lasers
    for ii = 1:num_wav     
        laser.z = 0;
        laser.r = alllasers_r(jj);  
    %     [rl, rb] =  dis_semiinfinite(vessel, laser);
    %      G(jj, ii) = Green_semi(mu_eff_bulk(ii), rl, rb);
         G(jj, ii) = cal_fluence(mu_eff_bulk(ii),vessel.z, ...
             sqrt(laser.r.^2 + vessel.z .^2));
         H(jj, ii) = G(jj,ii) * mua_vessel(ii);
    end
    H_aver(jj) = mean(H(jj,:));
end


%--------------- calculate ultrasound signal level END ----------------%
%------------------------------ plot START --------------------------- %
COLORs=hsv(num_lasers);
% for i=1:num_lasers; plot(1:10,rand(1,10),'col',COLORs(i,:)); end
% COLORs = jet(num_lasers);
% semilogy(wav, H(1,:)./H(1,1), 'color', [COLORs(1,:)])
 %      
% semilogy(  H_aver(1)./H_aver(1),'color',[ COLORs(jj,:)],'Marker', '+','MarkerSize',10)
% hold on
% str_legend(1) = {['D = ' num2str(sqrt(vessel.z^2 + alllasers_r(1)^2),4)]};
% if num_lasers > 1
%     for jj = 2:num_lasers
% %         semilogy(wav, H(jj,:)./H(1,1),'color',[ COLORs(jj,:)])
%         semilogy(  H_aver(jj)./H_aver(1),'color',[ COLORs(jj,:)],'Marker', '+','MarkerSize',10)
%         str_legend{jj} =  ['D = ' num2str(sqrt(vessel.z^2 + alllasers_r(jj)^2),4)];
%     end
% end

 
      
    
      semilogy( [0:2], H_aver(1)./H_aver(1) * ones(1,3),'LineWidth',3,'color',COLORs(1,:))
   hold on
str_legend(1) = {['D = ' num2str(sqrt(vessel.z^2 + alllasers_r(1)^2),2)]};
if num_lasers > 1
    for jj = 2:num_lasers
%         semilogy(wav, H(jj,:)./H(1,1),'color',[ COLORs(jj,:)])
        semilogy( [0:2], H_aver(jj)./H_aver(1) * ones(1,3),'LineWidth',3,'color',COLORs(jj,:))
        str_legend{jj} =  ['D = ' num2str(sqrt(vessel.z^2 + alllasers_r(jj)^2),2)];
    end
end
    
 Labels = {'Ultrasound Signal'};
      set(gca, 'XTick', 1, 'XTickLabel', Labels);

%   ymax = 1;
%       ymin = 0;
%       ylim([ymin ,ymax])
legend(str_legend,'Location','bestoutside')
% xlabel('wavelength [nm]')
hold off

%------------------------------ plot END ----------------------------- %
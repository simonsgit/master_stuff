function [U_y_init,U_ordering,U_params,activ_params,flux_params,intracom_params] = MRG_init(t,naxons)
    [U_axon, U_ordering, U_params] = AxonNode_Compart_init(t);
    
    if naxons > 1
        add_axon = horzcat(repmat([0;-80;0;0;0;0],1,10),U_axon);
        U_y_init = horzcat(U_axon,repmat(add_axon,1,naxons-1));
        
        % calculate flux parameters
        xc_n = 0;
        xc_in = 1e-9 / 240;
        xc = [xc_n;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_n;xc_in];
        %xraxial_n = 7e5 / (pi*((((3.3/2)+0.002)^2)-((3.3/2)^2)));
        %xraxial_m = 7e5 / (pi*((((3.3/2)+0.002)^2)-((3.3/2)^2)));
        %xraxial_f = 7e5 / (pi*((((6.9/2)+0.004)^2)-((6.9/2)^2)));
        %xraxial_s = 7e5 / (pi*((((6.9/2)+0.004)^2)-((6.9/2)^2)));
        %xraxial = [xraxial_n;xraxial_m;xraxial_f;xraxial_s;xraxial_s;xraxial_s;xraxial_s;xraxial_s;xraxial_s;xraxial_f;xraxial_m;xraxial_n;xraxial_m];
        Ra_n = 7e5;
        Ra_m = 7e5 * (10/3.3)^2;
        Ra_f = 7e5 * (10/6.9)^2;
        Ra_s = 7e5 * (10/6.9)^2;
        Ra = [Ra_n;Ra_m;Ra_f;Ra_s;Ra_s;Ra_s;Ra_s;Ra_s;Ra_s;Ra_f;Ra_m;Ra_n;Ra_m];
        l_n = 1;
        l_m = 3;
        l_f = 46;
        l_s = (1150-1-(2*3)-(2*46))/6;
        l = [l_n;l_m;l_f;l_s;l_s;l_s;l_s;l_s;l_s;l_f;l_m;l_n;l_m];
        d_n = 3.3;
        d_i = 10;
        d = [d_n;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_n;d_i];
        c_n = 2e-8;
        c_m = 2e-8 * (3.3/10);
        c_f = 2e-8 * (6.9/10);
        c_s = 2e-8 * (6.9/10);
        de = d + [0.004;0.004;0.008;0.008;0.008;0.008;0.008;0.008;0.008;0.008;0.004;0.004;0.004]; 
        cm = [c_n;c_m;c_f;c_s;c_s;c_s;c_s;c_s;c_s;c_f;c_m;c_n;c_m];
        cmxc = cm + xc;
        itaus = 1e-3.*(2*l).^2 .*Ra .*cm./d;
        itaus = vertcat(itaus, repmat(itaus(3:end),naxons-2,1));
        %itaus = repmat((1e-3.*(2*l).^2 .*Ra .*de .* ce.*cm)./(d.*(d.*cm+de.*ce)),naxons-1,1);
        etaus1 = 1e-3.*(2*l).^2 .*Ra .*cmxc./d;
        etaus1 = vertcat(etaus1,repmat(etaus1(3:end),naxons-2,1));
        etaus2 = (1e-3.*(2*l).^2 .*Ra_n .*cmxc.*de)./(de.^2-d.^2);
        etaus2 = vertcat(etaus2,repmat(etaus2(3:end),naxons-2,1));
        flux_params = struct();
        flux_params.int_taus = vertcat((itaus(1)+itaus(2))./2, (itaus(2:end) + itaus(1:end-1))./2);
        flux_params.ext_taus1 = vertcat((etaus1(1)+etaus1(2))./2, (etaus1(2:end) + etaus1(1:end-1))./2);
        flux_params.ext_taus2 = vertcat((etaus2(1)+etaus2(2))./2, (etaus2(2:end) + etaus2(1:end-1))./2);
        
        % calculate intracompartment parameters
        gpas_m = 3.3/10;
        gpas_f = 0.1 * 3.3/10;
        gpas_s = 0.1 * 3.3/10;
        gpas = [gpas_m;gpas_f;gpas_s;gpas_s;gpas_s;gpas_s;gpas_s;gpas_s;gpas_f;gpas_m];
        intracom_params = struct();
        intracom_params.ext = (1/240)./(cm(2:end-2).*2e8 + (0.1/240)); 
        intracom_params.int = gpas./(cm(2:end-2).*2e8);
    else
        U_y_init = U_axon;
        flux_params = 0;
    end
    % set activation parameters
    activ_params = struct();
    Cm = 2;
    activ_params.Cm = Cm;
    g_L = 7;
    activ_params.g_L = g_L;
    offset = 10;
    activ_params.offset = offset;
    bcl = 1000;
    activ_params.bcl = bcl;
    duration = 0.1;
    activ_params.n = 1;
    activ_params.duration = duration;
    strength = 2000;
    activ_params.strength = strength;
    
end
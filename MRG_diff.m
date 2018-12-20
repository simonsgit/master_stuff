function U_dydt = MRG_diff(t,y,U_params,activ_params,flux_params,intracom_params,naxons,flux,activn)
    
    %if mod(int32(t*10000),10) == 0
    %    fprintf(1, "%012.6f      \r", t*1000);
    %end

    if naxons > 1
              
        % calculate intracompartment diffvars
        U_vars = reshape(y,[6,1+(naxons-1)*11]);
        diff_U = zeros(size(U_vars));
        if activn == 1
            diff_U(1:6,1) = AxonNode_Compart(t,U_vars(:,1),activ_params);
        else
            diff_U(1:6,1) = AxonNode_Compart(t,U_vars(:,1),U_params);
        end
        
        %cm = [10,1,1,1,1,1,1,1,1,10] .* 0.05;
        
        for n = 1:naxons-1
            pas1 = 2+(n-1)*11;
            pas10 = 11+(n-1)*11;
            %diff_U(1,pas1:pas10) = cm .* (U_vars(2,pas1:pas10) - U_vars(1,pas1:pas10)+80)-10*(U_vars(1,pas1:pas10));
            %diff_U(2,pas1:pas10) = -10 .* (U_vars(1,pas1:pas10));
            diff_U(1,pas1:pas10) = -intracom_params.ext' .* (U_vars(1,pas1:pas10)) + intracom_params.ext' .* (U_vars(2,pas1:pas10) +80);%- U_vars(1,pas1:pas10)+80);
            diff_U(2,pas1:pas10) = -intracom_params.int' .* (U_vars(2,pas1:pas10) +80);%- U_vars(1,pas1:pas10)+80);% + diff_U(1,pas1:pas10);
            if n+1 == activn
                diff_U(1:6,12+(n-1)*11) = AxonNode_Compart(t,U_vars(1:6,1+n*11),activ_params);
            else
                diff_U(1:6,12+(n-1)*11) = AxonNode_Compart(t,U_vars(1:6,1+n*11),U_params);
            end
        end
        if flux == 1
            % copy intercompartment flux
            ext_taus1 = flux_params.ext_taus1;
            ext_taus2 = flux_params.ext_taus2;
            int_taus = flux_params.int_taus*0.01;
            %ext_taus = ext_taus(1).*ones(size(ext_taus));
            %int_taus = int_taus(1).*ones(size(int_taus));
            U_ext = U_vars(1,1:end).'; %transponses so array can correctly be padded
            U_int = U_vars(2,1:end).';
            %U_diff = U_int - U_ext;
            padU_ext = padarray(U_ext,1);
            padU_int = padarray(U_int,1,-80);
            %padU_diff = padU_int - padU_ext;
            flux_ext = ((padU_ext(1:end-2)-U_ext) ./ ext_taus2(1:end-1)) + ((padU_ext(3:end)-U_ext)./ext_taus2(2:end)) + ((padU_int(1:end-2)-U_int) ./ ext_taus1(1:end-1)) + ((padU_int(3:end)-U_int)./ext_taus1(2:end));
            flux_ext(1) = ((padU_ext(3)-U_ext(1)) ./ ext_taus2(2)) + ((padU_int(3)-U_int(1))./ext_taus1(2));
            flux_ext(end) = ((padU_ext(end-2)-U_ext(end)) ./ ext_taus2(end-1)) + ((padU_int(end-2)-U_int(end)) ./ ext_taus1(end-1));
            %flux_ext(1:11:end) = 0; %makes sure V_ext of the nodes stays grounded
            %flux_int = flux_ext+((padU_int(1:end-2)-U_int)./int_taus(1:end-1)) + ((padU_int(3:end)-U_int)./int_taus(2:end));
            flux_int = flux_ext + ((padU_int(1:end-2)-U_int) ./ int_taus(1:end-1)) + ((padU_int(3:end)-U_int)./int_taus(2:end));
            flux_int(1) = flux_ext(1) + (padU_int(3)-U_int(1))./int_taus(2);
            flux_int(end) = flux_ext(end) + (padU_int(end-2)-U_int(end))./int_taus(end-1);
            flux = vertcat(flux_ext.',flux_int.',zeros(4,1+(naxons-1)*11));
            
            U_dydt = reshape(diff_U + flux,[6+(naxons-1)*66,1]);
        else
            U_dydt = reshape(diff_U, [6+(naxons-1)*66,1]);
        end
    else
        U_dydt = AxonNode_Compart(t,y,activ_params);
    end
end
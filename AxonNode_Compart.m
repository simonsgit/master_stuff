function U_dydt = AxonNode_Compart(t,U_diffvars,varargin)

   U_dydt = zeros(6,1);
   % make copies of the differential vars
   V_ext = U_diffvars(1);
   V_int = U_diffvars(2);
   h = U_diffvars(3);
   m = U_diffvars(4);
   p = U_diffvars(5);
   s = U_diffvars(6);
   narginchk(2+0,3);
   if (nargin >= 3)
       U_params = varargin{1};
   else
      U_params = struct();
   end

   % define the differential update
   E_R = -80;
   E_Na = E_R + 130;
   if (isfield(U_params, 'Cm'))
      Cm = U_params.Cm;
   else
      Cm = 2;
      U_params.Cm = Cm;
   end
   g_Naf = 3000;
   E_L = E_R - 10;
   if (isfield(U_params, 'g_L'))
      g_L = U_params.g_L;
   else
      g_L = 20;
      U_params.g_L = g_L;
   end
   g_Nap = 10;
   E_K = E_R - 10;
   g_K = 80;
   if (isfield(U_params, 'offset'))
      offset = U_params.offset;
   else
      offset = 50;
      U_params.offset = offset;
   end
   if (isfield(U_params, 'n'))
      n = U_params.n;
   else
      n = 1;
      U_params.n = n;
   end
   if (isfield(U_params, 'bcl'))
      bcl = U_params.bcl;
   else
      bcl = 1000;
      U_params.bcl = bcl;
   end
   U__melodee_temp_011 = t < offset;
   if (U__melodee_temp_011)
      bcl_time = 1000*bcl - offset + t;
   else
      beat = floor((-offset + t)./bcl);
      U__melodee_temp_010 = beat >= n;
      if (U__melodee_temp_010)
         bcl_time_beat = n - 1;
      else
         bcl_time_beat = beat;
      end
      bcl_time = -bcl.*bcl_time_beat - offset + t;
   end
   if (isfield(U_params, 'duration'))
      duration = U_params.duration;
   else
      duration = 0;
      U_params.duration = duration;
   end
   if (isfield(U_params, 'strength'))
      strength = U_params.strength;
   else
      strength = 0;
      U_params.strength = strength;
   end
   iStim = 0;
   U__melodee_temp_012 = bcl_time < duration;
   if (U__melodee_temp_012)
      squareStim_iStim = strength;
      iStim_001 = squareStim_iStim;
   else
      iStim_001 = iStim;
   end
   V_diff = -V_ext + V_int;
   i_Naf = m.^3.*g_Naf.*h.*(V_diff - E_Na);
   I_mem_area = i_Naf;
   U__melodee_temp_004 = abs(V_diff/11 + 114/11) < 1.0e-6;
   if (U__melodee_temp_004)
      U__melodee_temp_005 = 4.18000000000000;
   else
      U__melodee_temp_005 = (-0.38*V_diff - 43.32)./(-exp(V_diff/11 + 114/11) + 1);
   end
   alpha_h = U__melodee_temp_005;
   beta_h = 14.1./(1 + 0.0931881856853705*exp(-0.0746268656716418*V_diff));
   h_diff = -h.*beta_h + alpha_h.*(-h + 1);
   U__melodee_temp_000 = abs(0.0970873786407767*V_diff + 2.07766990291262) < 1.0e-6;
   if (U__melodee_temp_000)
      U__melodee_temp_001 = 73.2330000000000;
   else
      U__melodee_temp_001 = (7.11*V_diff + 152.154)./(1 - 0.125221651130795*exp(-0.0970873786407767*V_diff));
   end
   alpha_m = U__melodee_temp_001;
   U__melodee_temp_002 = abs(0.109170305676856*V_diff + 2.8056768558952) < 1.0e-6;
   if (U__melodee_temp_002)
      U__melodee_temp_003 = 3.01364000000000;
   else
      U__melodee_temp_003 = (-0.329*V_diff - 8.4553)./(-16.5382661414812*exp(0.109170305676856*V_diff) + 1);
   end
   beta_m = U__melodee_temp_003;
   m_diff = -m.*beta_m + alpha_m.*(-m + 1);
   i_L = g_L.*(V_diff - E_L);
   leakage_current_I_mem_area = i_L;
   i_Nap = p.^3.*g_Nap.*(V_diff - E_Na);
   pers_sodium_channel_I_mem_area = i_Nap;
   U__melodee_temp_006 = abs(0.0980392156862745*V_diff + 2.64705882352941) < 1.0e-6;
   if (U__melodee_temp_006)
      U__melodee_temp_007 = 0.389640000000000;
   else
      U__melodee_temp_007 = (0.0382*V_diff + 1.0314)./(1 - 0.0708593166305464*exp(-0.0980392156862745*V_diff));
   end
   alpha_p = U__melodee_temp_007;
   U__melodee_temp_008 = abs(V_diff/10 + 17/5) < 1.0e-6;
   if (U__melodee_temp_008)
      U__melodee_temp_009 = 0.00955000000000000;
   else
      U__melodee_temp_009 = (-0.000955*V_diff - 0.03247)./(-exp(V_diff/10 + 17/5) + 1);
   end
   beta_p = U__melodee_temp_009;
   p_diff = -p.*beta_p + alpha_p.*(-p + 1);
   i_K = g_K.*s.*(V_diff - E_K);
   slow_potassium_channel_I_mem_area = i_K;
   alpha_s = 0.3348./(exp(-V_diff/5 - 53/5) + 1);
   beta_s = 0.03348./(exp(-V_diff - 90) + 1);
   s_diff = -s.*beta_s + alpha_s.*(-s + 1);
   I_out = 1000*V_ext;
   I_out_001 = I_out;
   MRGHH_I_mem_area = I_mem_area + leakage_current_I_mem_area + pers_sodium_channel_I_mem_area + slow_potassium_channel_I_mem_area;
   I_mem = MRGHH_I_mem_area./Cm;
   I_mem_001 = I_mem;
   V_ext_diff = I_mem_001 - I_out_001;
   V_int_diff = V_ext_diff - I_mem_001 + iStim_001;
   % stuff the differential update into an array
   U_dydt(1) = V_ext_diff;
   U_dydt(2) = V_int_diff;
   U_dydt(3) = h_diff;
   U_dydt(4) = m_diff;
   U_dydt(5) = p_diff;
   U_dydt(6) = s_diff;
end

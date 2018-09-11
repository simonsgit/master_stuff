function [U_y_init, U_ordering, U_params] = AxonNode_Compart_init(t,varargin)
   narginchk(1+0,2);
   if (nargin > 1)
      U_params = varargin{1};
   else
      U_params = struct();
   end



   %define the initial conditions
   V_ext_init = 0;
   V_int_init = V_ext_init - 80;
   if (isfield(U_params, 'Cm'))
      Cm = U_params.Cm;
   else
      Cm = 2;
      U_params.Cm = Cm;
   end
   h_init = 0.620700000000000;
   h = h_init;
   m_init = 0.0732000000000000;
   m = m_init;
   if (isfield(U_params, 'g_L'))
      g_L = U_params.g_L;
   else
      g_L = 20;
      U_params.g_L = g_L;
   end
   p_init = 0.202600000000000;
   p = p_init;
   s_init = 0.0430000000000000;
   s = s_init;
   V_V_int_init = V_int_init;
   V_int = V_V_int_init;
   V_V_ext_init = V_ext_init;
   V_ext = V_V_ext_init;
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
   U_y_init = zeros(6, 1);
   U_y_init(1) = V_ext;
   U_y_init(2) = V_int;
   U_y_init(3) = h;
   U_y_init(4) = m;
   U_y_init(5) = p;
   U_y_init(6) = s;
   U_ordering = struct();
   U_ordering.V_ext = 1;
   U_ordering.V_int = 2;
   U_ordering.h = 3;
   U_ordering.m = 4;
   U_ordering.p = 5;
   U_ordering.s = 6;
end


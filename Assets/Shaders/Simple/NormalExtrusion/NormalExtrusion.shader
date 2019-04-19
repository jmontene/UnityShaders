﻿Shader "Custom/Simple/NormalExtrusion"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Amount ("Extrusion Amount", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

        sampler2D _MainTex;
		float _Amount;

		void vert(inout appdata_full v) {
			v.vertex.xyz += v.normal * _Amount;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

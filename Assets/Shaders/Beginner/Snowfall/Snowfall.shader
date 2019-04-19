// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Beginner/Snowfall"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
		_MainColor("Color", Color) = (1,1,1,1)
		_Bump("Bump", 2D) = "bump" {}
		_Snow("Level of snow", Range(1, -1)) = 1
		_SnowColor("Color of snow", Color) = (1.0,1.0,1.0,1.0)
		_SnowDirection("Direction of snow", Vector) = (0,1,0)
		_SnowDepth("Depth of snow", Range(0,0.1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _Bump;
		float _Snow;
		float4 _SnowColor;
		float4 _MainColor;
		float4 _SnowDirection;
		float _SnowDepth;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
        };

		void vert(inout appdata_full v) {
			float4 sn = mul(_SnowDirection, unity_WorldToObject);
			float normalDotSn = dot(v.normal, sn.xyz);
			float isGtSnow = step(_Snow, normalDotSn);
			v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow * isGtSnow;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
			float normalDotSnow = dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz);
			float isGtSnow = step(_Snow, normalDotSnow);
			o.Albedo = _SnowColor.rgb * isGtSnow + (c.rgb * _MainColor) * (1 - isGtSnow);
			o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

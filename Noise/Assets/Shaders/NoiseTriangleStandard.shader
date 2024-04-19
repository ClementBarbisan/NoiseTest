Shader "Custom/NoiseTriangleStandard"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 4.6
        #include "UnityCG.cginc"
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        int nbInstance;
        #ifdef SHADER_API_D3D11
        StructuredBuffer<float3> particleBuffer;
        #endif
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        
        struct appdata{
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
            uint id : SV_VertexID;
            uint inst : SV_instanceID;
         };
        
        void vert(inout appdata o)
        {
            #ifdef SHADER_API_D3D11
            o.vertex = UnityObjectToClipPos(float4(particleBuffer[o.inst + o.id * nbInstance].xyz * 75.0 , 1.0));
            #endif
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

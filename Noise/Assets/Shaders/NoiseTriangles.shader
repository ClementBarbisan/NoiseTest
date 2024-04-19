Shader "Unlit/NoiseTriangles"
{
    Properties
    {
    }
    SubShader
    {
        

        Pass
        {
            Tags
            {
                "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"
            }
            Cull Off
            LOD 100
            CGPROGRAM
            #pragma vertex vert
            //#pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Pixel shader input
            struct PS_INPUT
            {
                float4 position : SV_POSITION;
                uint instance : SV_InstanceID;
                float size: PSIZE;
            };
            int nbInstance;
            StructuredBuffer<float3> particleBuffer;

            float rand(in float2 uv)
            {
                float2 noise = (frac(sin(dot(uv, float2(12.9898, 78.233) * 2.0)) * 43758.5453));
                return abs(noise.x + noise.y) * 0.5;
            }
            
            PS_INPUT vert(uint vertex_id : SV_VertexID)
            {
                PS_INPUT o = (PS_INPUT)0;
                //o.instance = vertex_id;
                o.position = UnityObjectToClipPos(float4(particleBuffer[vertex_id].xyz * 50.0 , 1.0));
                o.size = 2;
                return o;
            }

            [maxvertexcount(3)]
            void geom(point PS_INPUT p[1], inout TriangleStream<PS_INPUT> triStream)
            {
                PS_INPUT o;
                o.size = 2;
                o.position = float4(particleBuffer[p[0].instance].xyz * 10.0 , 1.0);
                triStream.Append(o);
                o.position = float4(particleBuffer[p[0].instance + nbInstance].xyz * 10.0 , 1.0);
                triStream.Append(o);
                o.position = float4(particleBuffer[p[0].instance + nbInstance * 2].xyz * 10.0 , 1.0);
                triStream.Append(o);
            }
            
            fixed4 frag (PS_INPUT i) : SV_Target
            {
                // sample the texture
                fixed4 col = float4(1.0, 1.0, 1.0, 0.5);
                // apply fog
                return col;
            }
            ENDCG
        }
    }
}

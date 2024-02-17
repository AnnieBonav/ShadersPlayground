Shader "Unlit/AllMasking"
{
    Properties
    {
        _MainTex("Base (RGB), Alpha (A)", 2D) = "white" {} // Show White
        _Offset("Vertex Offset", float) = 0.0
        _Skew("Skew", Vector) = (0,0,0,0)
        _TimeChange("Time", float) = 1
    }
        SubShader
        {
            Tags { "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Opaque"}

            Pass
            {
                // Blend One One
                // Blend 1 Off
                // Blend Off 1 // Error
                // Blend One Zero
                // Blend 1 One Zero
                // Blend One Zero, Zero One
                // Blend One Zero, Zero One
                //Blend SrcAlpha One
                Blend SrcAlpha One
                //Blend SrcAlphaSaturate Zero
                //Blend SrcAlphaSaturate One
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                #define TAU 6.28318530718 

                float _Offset;
                float4 _Skew;
                float _TimeChange;
                sampler2D _MainTex;
                float4 _MainTex_ST; // Optional?

                struct MeshData
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct Interpolators
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                Interpolators vert(MeshData v)
                {
                    Interpolators o;
                    o.uv = v.uv;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    return o;
                }

                fixed4 frag(Interpolators i) : SV_Target
                {
                    float4 tex = tex2D(_MainTex, i.uv);
                    float clamped = clamp(i.uv, 0.5, 0.9);
                    float4 colorWithAlpha = float4(tex.x, tex.y, tex.z, 0.5);
                    return float4(1 - tex);
                    // return float4(tex.xyz, (1-tex.a)); // Werid
                    return float4(i.uv.xy,1, 0.1);
                    return colorWithAlpha;
                    return clamped;
                }
            ENDCG
        }
        }
}

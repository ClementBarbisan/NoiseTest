using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateNoiseTriangle : MonoBehaviour
{
    private float[] _dataAudio;
    private Vector3[] _dataBuffer;
    private bool _dataCollected;
    private ComputeBuffer _bufferAudio;
    [SerializeField] private Material _noiseTriangle;

    // Update is called once per frame
    void Update()
    {
        if (_dataAudio != null && _bufferAudio == null)
        {
            _bufferAudio = new ComputeBuffer(_dataAudio.Length / 3, 3 * sizeof(float));
            _dataBuffer = new Vector3[_dataAudio.Length / 3];
            _noiseTriangle.SetBuffer("particleBuffer", _bufferAudio);
            _noiseTriangle.SetInt("nbInstance", _dataAudio.Length / 3);
        }

        if (_dataAudio != null && _dataCollected)
        {
            for (int i = 0; i + 2 < _dataAudio.Length; i += 3)
            {
                _dataBuffer[i / 3] = new Vector3(_dataAudio[i], _dataAudio[i + 1], _dataAudio[i + 2]);
            }
            _bufferAudio.SetData(_dataBuffer);
            _dataCollected = false;
           
        }

        if (_bufferAudio != null)
        {
            Graphics.DrawProcedural(
                _noiseTriangle,
                new Bounds(Vector3.zero, Vector3.one * 5),
                MeshTopology.Triangles, _dataAudio.Length / 3);
        }
    }

    private void OnRenderObject()
    {
        if (_dataBuffer == null)
        {
            return;
        }
        //_noiseTriangle.SetPass(0);
        //Graphics.DrawProceduralNow(MeshTopology.Triangles, _dataAudio.Length / 3);
    }

    private void OnAudioFilterRead(float[] data, int channels)
    {
        if (_dataCollected)
        {
            return;
        }
        int dataLen = data.Length / channels;
        if (_dataAudio == null)
        {
            _dataAudio = new float[data.Length];
        }
        
        int n = 0;
        while (n < dataLen)
        {
            int i = 0;
            while (i < channels)
            {
                _dataAudio[n * channels + i] = data[n * channels + i];
                i++;
            }
            n++;
        }
        _dataCollected = true;
    }

    private void OnDestroy()
    {
        _bufferAudio?.Dispose();
    }
}

# Planophile
import csv
import prosail
import numpy as np

# CSV�ļ���
csv_file = './Planophile.csv'

# ��CSV�ļ�׼��д��
with open(csv_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    
    # д������ͷ��
    writer.writerow(['lai', 'ndvi', 'ndii'])

    # ѭ��������ͬ�� lai ֵ
    for lai_value in np.arange(0.01, 10.01, 0.01):
        # ���� prosail ����ȡ rho_canopy ���
        rho_canopy = prosail.run_prosail(n=1.4, cab=40, car=8, cbrown=0, cw=0.02, cm=0.01, lai=lai_value, lidfa=1, hspot=0.15, tts=30, tto=45, psi=90, \
                        ant=0.0, alpha=40.0, prospect_version='5', typelidf=1, lidfb=0, \
                        factor='SDR', rsoil0=0.2, rsoil=None, psoil=None, \
                        soil_spectrum1=None, soil_spectrum2=None)
        
        # �����д�� CSV �ļ�
        
        
        
#         writer.writerow([round(lai_value, 1)]+ list(rho_canopy))
        
        mean_770_900 = np.mean(rho_canopy[770-400:900+1-400])
        mean_630_690 = np.mean(rho_canopy[630-400:690+1-400])
        mean_1550_1750 = np.mean(rho_canopy[1550-400:1750+1-400])
        ndvi = (mean_770_900 - mean_630_690) / (mean_770_900 + mean_630_690)
        ndii = (mean_770_900 - mean_1550_1750) / (mean_770_900 + mean_1550_1750)
        
        writer.writerow([round(lai_value, 2), ndvi, ndii])

        # ���ÿ��0.1��Ӧ�Ľ��
        print(f"lai={round(lai_value, 1)}: {rho_canopy}")

print("�����ѱ��浽 CSV �ļ��������ÿ��0.1��Ӧ�Ľ����")

seq 100 100 5000 | parallel java -cp simpaths.jar simpaths.experiment.SimPathsMultiRun -r {} -n 20 -p 150000 -s 2017 -e 2025 -g false -f
Rscript R/combining_arrow_data.R reform_sens
# cp -r out_data/reform_sens /mnt/t/projects/HEED/DataAnalysis/simpaths_out_multirun/arrow_files/
rm -r output/2023*/database
rm -r output/2023*/input
tar -cv -I 'pigz --zip' -f /storage/andy/simpaths_outputs/csvs/reform_sens_outputs.tar.zip /storage/andy/simpaths_outputs/output
# cp -r /storage/andy/simpaths_outputs/output /mnt/t/projects/HEED/DataAnalysis/simpaths_out_multirun/csvs/reform_sens_outputs/
# Rscript R/rewrite_files_to_arrow.R baseline_sens
# cp -r out_data/baseline_sens /mnt/t/projects/HEED/DataAnalysis/simpaths_out_multirun/arrow_files/
curl "https://api.telegram.org/bot${Notify_bot_key}/sendMessage?text=Done%20copying%20all%20files&chat_id=${telegram_chatid}"

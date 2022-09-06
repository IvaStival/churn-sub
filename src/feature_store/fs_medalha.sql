<<<<<<< HEAD
SELECT '2021-11-01' as dtRef,
=======
SELECT  '{date}' as dtRef,
>>>>>>> cdc13312515a0c147cad7bbfb08d792bb4e178a2
        t1.idPlayer,
        count(DISTINCT t1.idMedal) as qtMedalhaDist,
        count(t1.idMedal) as qtMedalha,
        count(case when t2.descMedal in ('#YADINHO - Eu Fui!', 
                                         'Missão da Tribo', 
                                         'Tribo Gaules') then t1.idMedal end) as qtMedalhaTribo,
<<<<<<< HEAD

=======
>>>>>>> cdc13312515a0c147cad7bbfb08d792bb4e178a2
        count(case when t2.descMedal = "Experiência de Batalha" then t1.idMedal end) as qtExpBatalha

FROM tb_players_medalha AS t1

LEFT JOIN tb_medalha AS t2
ON t1.idMedal = t2.idMedal

WHERE t1.dtCreatedAt < t1.dtExpiration
AND t1.dtCreatedAt < COALESCE(t1.dtRemove, DATE('now'))
<<<<<<< HEAD
AND t1.dtCreatedAt < "2021-11-01"
GROUP BY t1.idPlayer
=======
AND t1.dtCreatedAt < '{date}'
GROUP BY t1.idPlayer;
>>>>>>> cdc13312515a0c147cad7bbfb08d792bb4e178a2

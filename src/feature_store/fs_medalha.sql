SELECT  '{date}' as dtRef,
        t1.idPlayer,
        count(DISTINCT t1.idMedal) as qtMedalhaDist,
        count(t1.idMedal) as qtMedalha,
        count(case when t2.descMedal in ('#YADINHO - Eu Fui!', 
                                         'Missão da Tribo', 
                                         'Tribo Gaules') then t1.idMedal end) as qtMedalhaTribo,
        count(case when t2.descMedal = "Experiência de Batalha" then t1.idMedal end) as qtExpBatalha

FROM tb_players_medalha AS t1

LEFT JOIN tb_medalha AS t2
ON t1.idMedal = t2.idMedal

WHERE t1.dtCreatedAt < t1.dtExpiration
AND t1.dtCreatedAt < COALESCE(t1.dtRemove, DATE('now'))
AND t1.dtCreatedAt < '{date}'
GROUP BY t1.idPlayer;

WITH tb_assinaturas as (
    SELECT  t1.*,
            t2.descMedal

    FROM tb_players_medalha AS t1

    LEFT JOIN tb_medalha AS t2
    ON t1.idMedal = t2.idMedal

    WHERE t1.dtCreatedAt < t1.dtExpiration
    AND t1.dtCreatedAt < COALESCE(t1.dtRemove, t1.dtExpiration,  DATE('now'))
    AND t1.dtCreatedAt < "{date}"
    AND COALESCE(t1.dtRemove, t1.dtExpiration, DATE('now')) > "{date}"
    AND t2.descMedal in ('Membro Premium', 'Membro Plus')
    GROUP BY t1.idPlayer
),

tb_assinaturas_rn as (
    SELECT t1.*, 
        ROW_NUMBER() over (PARTITION BY idPlayer ORDER BY dtExpiration DESC) as rn_assinatura
    FROM tb_assinaturas as t1
    ORDER BY idPlayer
),

tb_assinatura_sumario as (
    SELECT * ,
            JULIANDAY("{date}") - JULIANDAY(dtCreatedAt) as qtDiasAssinatura,
            JULIANDAY(dtExpiration) - JULIANDAY("{date}") as qtDiasExpiracaoAssinatura

    FROM tb_assinaturas_rn 
    WHERE rn_assinatura = 1
    GROUP BY idPlayer
),

tb_assinatura_hist as (
    SELECT  t1.idPlayer,
            count(t1.idMedal) as qtAssinatura,
            count(case when t2.descMedal = 'Membro Premium' then t1.idMedal end) as qtPremium,
            count(case when t2.descMedal = 'Membro Plus' then t1.idMedal end) as qtPlus
            
    FROM tb_players_medalha AS t1

    LEFT JOIN tb_medalha AS t2
    ON t1.idMedal = t2.idMedal

    WHERE t1.dtCreatedAt < t1.dtExpiration
    AND t1.dtCreatedAt < COALESCE(t1.dtRemove, DATE('now'))
    AND t1.dtCreatedAt < "{date}"
    AND COALESCE(t1.dtRemove, date('now')) > "{date}"
    AND t2.descMedal in ('Membro Premium', 'Membro Plus')
    GROUP BY t1.idPlayer
)

SELECT  "{date}" as dtRef,
        t1.idPlayer,
        t1.descMedal,
        1 as flAssinatura,
        t1.qtDiasAssinatura,
        t1.qtDiasExpiracaoAssinatura,
        t2.qtAssinatura,
        t2.qtPremium,
        t2.qtPlus

from tb_assinatura_sumario as t1

LEFT JOIN tb_assinatura_hist as t2
ON t1.idPlayer = t2.idPlayer;

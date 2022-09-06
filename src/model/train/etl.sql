DROP TABLE IF EXISTS abt_model_churn;

CREATE TABLE abt_model_churn as 

WITH  tb_features as (

    SELECT  t1.*,
            t2.qtPartidas,
            t2.qtDias,
            t2.propDia1,
            t2.propDia2,
            t2.propDia3,
            t2.propDia4,
            t2.propDia5,
            t2.propDia6,
            t2.propDia7,
            t2.qtRecencia,
            t2.winRate,
            t2.avgHsRate,
            t2.vlHsRate,
            t2.avgKDA,
            t2.vlKDA,
            t2.avgKDR,
            t2.vlKDR,
            t2.avgKill,
            t2.avgAssist,
            t2.avgDeath,
            t2.avgHs,
            t2.avgBombeDefuse,
            t2.avgBombePlant,
            t2.avgTk,
            t2.avgTkAssist,
            t2.avg1Kill,
            t2.avg2Kill,
            t2.avg3Kill,
            t2.avg4Kill,
            t2.avg5Kill,
            t2.avgPlusKill,
            t2.avgFirstKill,
            t2.avgDamage,
            t2.avgHits,
            t2.avgShots,
            t2.avgLastAlive,
            t2.avgClutchWon,
            t2.avgRoundsPlayed,
            t2.avgSurvived,
            t2.avgTrade,
            t2.avgFlashAssist,
            t2.propMirage,
            t2.propNuke,
            t2.propInferno,
            t2.propVertigo,
            t2.propAncient,
            t2.propDust2,
            t2.propTrain,
            t3.qtMedalhaDist,
            t3.qtMedalha,
            t3.qtMedalhaTribo,
            t3.qtExpBatalha

    FROM fs_assinatura AS t1

    LEFT JOIN fs_gameplay as t2
    ON t1.dtRef = t2.dtRef
    AND t1.idPlayer = t2.idPlayer

    LEFT JOIN fs_medalha as t3
    ON t1.dtRef = t3.dtRef
    AND t1.idPlayer = t3.idPlayer

    WHERE t1.dtRef <= DATE('2022-02-10', '-30 days')
)

SELECT t1.*,
        COALESCE(t2.flAssinatura, 0) as flNaoChurn, -- VARIAVEL TARGET
        t2.dtRef

FROM tb_features as t1
LEFT JOIN fs_assinatura as t2 
ON t1.idPlayer = t2.idPlayer
AND t1.dtRef = DATE(t2.dtRef, "-30 days");


-- SELECT name FROM pragma_table_info('fs_gameplay') ORDER BY cid
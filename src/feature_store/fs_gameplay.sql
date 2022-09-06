WITH tb_level AS (

    SELECT idPlayer, vlLevel, dtCreatedAt,
            ROW_NUMBER() over (PARTITION BY idPlayer ORDER BY dtCreatedAt DESC) as rnPlayer
    FROM tb_lobby_stats_player
<<<<<<< HEAD
    WHERE dtCreatedAt < "{date}"
    AND dtCreatedAt >= DATE("{date}", "-30 days")
=======
    WHERE dtCreatedAt < '{date}'
    AND dtCreatedAt >= DATE('{date}', "-30 days")
>>>>>>> cdc13312515a0c147cad7bbfb08d792bb4e178a2

    ORDER BY idPlayer, dtCreatedAt
), 

tb_level_final AS (
    SELECT * 
    FROM tb_level
    WHERE rnPlayer = 1
),

tb_player_stats AS (

    SELECT idPlayer,
            count(DISTINCT idLobbyGame) as qtPartidas,
            count(DISTINCT date(dtCreatedAt)) as qtDias,

            1.0*count(DISTINCT case when strftime('%w', dtCreatedAt)+1 = 1 then date(dtCreatedAt) end) / count(DISTINCT date(dtCreatedAt)) as propDia1,
            1.0*count(DISTINCT case when strftime('%w', dtCreatedAt)+1 = 2 then date(dtCreatedAt) end) / count(DISTINCT date(dtCreatedAt)) as propDia2,
            1.0*count(DISTINCT case when strftime('%w', dtCreatedAt)+1 = 3 then date(dtCreatedAt) end) / count(DISTINCT date(dtCreatedAt)) as propDia3,
            1.0*count(DISTINCT case when strftime('%w', dtCreatedAt)+1 = 4 then date(dtCreatedAt) end) / count(DISTINCT date(dtCreatedAt)) as propDia4,
            1.0*count(DISTINCT case when strftime('%w', dtCreatedAt)+1 = 5 then date(dtCreatedAt) end) / count(DISTINCT date(dtCreatedAt)) as propDia5,
            1.0*count(DISTINCT case when strftime('%w', dtCreatedAt)+1 = 6 then date(dtCreatedAt) end) / count(DISTINCT date(dtCreatedAt)) as propDia6,
            1.0*count(DISTINCT case when strftime('%w', dtCreatedAt)+1 = 7 then date(dtCreatedAt) end) / count(DISTINCT date(dtCreatedAt)) as propDia7,

<<<<<<< HEAD
            min(JULIANDAY(date("{date}")) - JULIANDAY(date(dtCreatedAt))) as qtRecencia,
=======
            min(JULIANDAY(date('{date}')) - JULIANDAY(date(dtCreatedAt))) as qtRecencia,
>>>>>>> cdc13312515a0c147cad7bbfb08d792bb4e178a2
            avg(flWinner) as winRate,
            avg(1.0 * qtHs / qtKill) as avgHsRate,
            1.0 * sum(qtHs) / sum(qtKill) as vlHsRate,
            avg(1.0 * (qtKill + qtAssist) / COALESCE(qtDeath, 1)) as avgKDA,
            COALESCE(1.0 * sum(qtKill + qtAssist) / sum(COALESCE(qtDeath, 1)), 0) as vlKDA,

            avg(1.0 * COALESCE(qtKill,0) / COALESCE(qtDeath, 1)) as avgKDR,
            1.0 * sum(COALESCE(qtKill,0)) / sum(COALESCE(qtDeath, 1)) as vlKDR,

            avg(qtKill) as avgKill,
            avg(qtAssist) as avgAssist,
            avg(qtDeath) as avgDeath,
            avg(qtHs) as avgHs,
            avg(qtBombeDefuse) as avgBombeDefuse,
            avg(qtBombePlant) as avgBombePlant,
            avg(qtTk) as avgTk,
            avg(qtTkAssist) as avgTkAssist,
            avg(qt1Kill) as avg1Kill,
            avg(qt2Kill) as avg2Kill,
            avg(qt3Kill) as avg3Kill,
            avg(qt4Kill) as avg4Kill,
            avg(qt5Kill) as avg5Kill,
            avg(qtPlusKill) as avgPlusKill,
            avg(qtFirstKill) as avgFirstKill,
            avg(vlDamage) as avgDamage,
            avg(qtHits) as avgHits,
            avg(qtShots) as avgShots,
            avg(qtLastAlive) as avgLastAlive,
            avg(qtClutchWon) as avgClutchWon,
            avg(qtRoundsPlayed) as avgRoundsPlayed,

            avg(qtSurvived) as avgSurvived,
            avg(qtTrade) as avgTrade,
            avg(qtFlashAssist) as avgFlashAssist,

            count(DISTINCT case when descMapName = 'de_mirage' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propMirage,
            count(DISTINCT case when descMapName = 'de_nuke' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propNuke,
            count(DISTINCT case when descMapName = 'de_inferno' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propInferno,
            count(DISTINCT case when descMapName = 'de_vertigo' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propVertigo,
            count(DISTINCT case when descMapName = 'de_ancient' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propAncient,
            count(DISTINCT case when descMapName = 'de_dust2' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propDust2,
            count(DISTINCT case when descMapName = 'de_train' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propTrain,
            count(DISTINCT case when descMapName = 'de_overpass' then idLobbyGame end)*1.0 / count(DISTINCT idLobbyGame) as propOverpass

    
    FROM tb_lobby_stats_player
<<<<<<< HEAD
    WHERE dtCreatedAt < "{date}"
    AND dtCreatedAt >= DATE("{date}", "-30 days")
=======
    WHERE dtCreatedAt < '{date}'
    AND dtCreatedAt >= DATE('{date}', "-30 days")
>>>>>>> cdc13312515a0c147cad7bbfb08d792bb4e178a2
    GROUP BY idPlayer

)

<<<<<<< HEAD
SELECT "{date}" as dtRef,
=======
SELECT '{date}' as dtRef,
>>>>>>> cdc13312515a0c147cad7bbfb08d792bb4e178a2
        t1.*,
        t2.vlLevel
FROM tb_player_stats AS t1
LEFT JOIN tb_level_final AS t2
WHERE t1.idPlayer = t2.idPlayer
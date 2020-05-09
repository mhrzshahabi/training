package com.nicico.training.repository;

import com.nicico.training.model.Skill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SkillDAO extends JpaRepository<Skill, Long>, JpaSpecificationExecutor<Skill> {
    @Query(value = "select nvl(max(s.c_code),'0') maxCode from tbl_skill s  where s.c_code like :skillCodeStart%", nativeQuery = true)
    String findMaxSkillCode(@Param("skillCodeStart") String skillCodeStart);

    @Query(value = "SELECT * FROM tbl_skill ts where Not Exists(select * from TBL_COMPETENCE_SKILL tcs where ts.id=tcs.F_SKILL_ID) and " +
            " Not Exists(select * from TBL_SKILL_SKILLGROUP tsg where ts.id=tsg.F_SKILL_ID) and  Not Exists(select * from TBL_SKILL_COURSE tsc where ts.id=tsc.F_SKILL_ID)    and id=?", nativeQuery = true)
    Skill getSkillUsedInOther(Long skillId);

    List<Skill> findByCourseIsNull();

    List<Skill> findByCourseIdIsNullAndCourseMainObjectiveIdIsNull();

    List<Skill> findByCourseMainObjectiveId(Long id);

    List<Skill> findSkillsByCourseMainObjectiveId(Long courseId);

    @Modifying
    @Query(value = "delete from \"DEVTRAINING\".\"TBL_SKILL\" where id=:id",nativeQuery = true)
    void deleteByIdQuery(Long id);
}

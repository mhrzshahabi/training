package com.nicico.training.repository;

import com.nicico.training.model.SkillGroup;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SkillGroupDAO extends JpaRepository<SkillGroup, Long>, JpaSpecificationExecutor<SkillGroup> {
    @Query(value = "select s.* from training.tbl_skill_group s  where Not EXISTS(select F_SKILLGROUP_ID from training.TBL_SKILL_SKILLGROUP ss where  ss.F_SKILLGROUP_ID=s.ID and ss.F_SKILL_ID = ?)", nativeQuery = true)
    List<SkillGroup> getUnAttachedSkillGroupsBySkillId(Long skillId, Pageable pageable);

    @Query(value = "select count(*) from training.tbl_skill_group s  where Not EXISTS(select F_SKILLGROUP_ID from training.TBL_SKILL_SKILLGROUP ss where  ss.F_SKILLGROUP_ID=s.ID and ss.F_SKILL_ID = ?)", nativeQuery = true)
    Integer getUnAttachedSkillGroupsCountBySkillId(Long skillId);
}
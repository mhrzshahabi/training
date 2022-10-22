package com.nicico.training.repository;

import com.nicico.training.model.PersonnelRegistered;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public interface PersonnelRegisteredDAO extends JpaRepository<PersonnelRegistered, Long>, JpaSpecificationExecutor<PersonnelRegistered> {

    Optional<PersonnelRegistered> findOneByPersonnelNo(String personnelNo);

    Optional<PersonnelRegistered> findByNationalCodeAndDeleted(String nationalCode,Long  deleted);

    PersonnelRegistered[] findAllByNationalCode(String nationalCode);

    List<PersonnelRegistered> findByPersonnelNoInOrPersonnelNo2In(List<String> personnelNos, List<String> personnelNos2);

    PersonnelRegistered findPersonnelRegisteredByPersonnelNo(String personnelNo);

    List<PersonnelRegistered> findAllByNationalCodeOrderByIdDesc(String nationalCode);

    List<PersonnelRegistered> findAllByPersonnelNoOrderByIdDesc(String personnelNo);

    @Query(value = "select * from tbl_personnel_registered where f_contact_info = :id and active = 1" , nativeQuery = true)
    Optional<PersonnelRegistered> findByContactInfoId(Long id);

    @Query(value = "select * from tbl_personnel_registered where f_contact_info IN(:ids)" , nativeQuery = true)
    List<PersonnelRegistered> findAllByContactInfoIds(List<Long> ids);

    @Query(value = "SELECT  tbl_personnel_registered.* FROM    tbl_personnel_registered INNER JOIN tbl_contact_info ON tbl_personnel_registered.f_contact_info = tbl_contact_info.id WHERE tbl_personnel_registered.active = 1 AND ( ( tbl_contact_info.c_mobile =:mobile ) OR ( tbl_contact_info.c_mobile2 =:mobile ))" , nativeQuery = true)
    List<PersonnelRegistered> findAllByMobile(String mobile);

    @Query(value = "update  tbl_personnel_registered set f_contact_info=null where f_contact_info IN(:ids)" , nativeQuery = true)
    List<PersonnelRegistered> setNullToContactInfo(List<Long> ids);

    @Query(value = "select registered.NATIONAL_CODE AS " + "\"code\"" +
            ",contact.C_MOBILE AS"+ "\"mobile\""+
            " from TBL_PERSONNEL_REGISTERED registered \n" +
            "left join TBL_CONTACT_INFO contact on contact.ID = registered.F_CONTACT_INFO "+
            "WHERE contact.C_MOBILE like :mobile AND registered.NATIONAL_CODE = :nationalCode",nativeQuery = true)
    List<Map<String,Object>> findAllByNationalCodeAndMobileNumber(@Param("mobile") String mobileNumber, @Param("nationalCode") String nationalCode);

    @Query(value = "\n" +
            "SELECT\n" +
            "    f_contact_info,COUNT(*)\n" +
            "FROM tbl_personnel_registered\n" +
            "GROUP BY\n" +
            "    f_contact_info\n" +
            "    HAVING \n" +
            "    COUNT(*) > 1" , nativeQuery = true)
    List<Object> getReapeatlyPhones();

    @Modifying
    @Query(value = "update  tbl_personnel_registered set national_code = :nationalCode ,  e_deleted = null where id =:id ", nativeQuery = true)
    void editNationalCode(@Param("id") Long id,@Param("nationalCode") String nationalCode);


     Optional<PersonnelRegistered> findFirstByNationalCodeAndActive(String nationalCode,Integer active);

}



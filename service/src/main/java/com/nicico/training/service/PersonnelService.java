/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.SysUserInfoModel;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.PersonnelRegistered;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.model.ViewActivePersonnelInRegistering;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
@RequiredArgsConstructor
public class PersonnelService implements IPersonnelService {

    private final PersonnelDAO personnelDAO;
    private final PersonnelRegisteredDAO personnelRegisteredDAO;
    private final SynonymPersonnelDAO synonymPersonnelDAO;
    private final ModelMapper modelMapper;
    private final PostDAO postDAO;
    private final TclassDAO tclassDAO;
    private final ViewActivePersonnelInRegisteringDAO viewActivePersonnelInRegisteringDAO;

    @Autowired
    EntityManager entityManager;

    //Unused
    @Transactional(readOnly = true)
    @Override
    public List<PersonnelDTO.Info> list() {
        return modelMapper.map(personnelDAO.findAll(), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public PersonnelDTO.Info get(Long id) {
        return modelMapper.map(getPersonnel(id), PersonnelDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Personnel getPersonnel(Long id) {
        return personnelDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(personnelDAO, request, Personnel -> modelMapper.map(Personnel, PersonnelDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(personnelDAO, request, Personnel -> modelMapper.map(Personnel, PersonnelDTO.Info.class));
    }

    @Transactional
    @Override
    public List<PersonnelDTO.InfoForStudent> checkPersonnelNos(List<String> personnelNos, Long courseId) {
        List<PersonnelDTO.InfoForStudent> result = new ArrayList<>();
        String query = "SELECT PERSONNEL_NO,IS_IN_NA,CLASS_STUDENT_SCORES_STATE_ID FROM view_active_personnel_for_register_in_class WHERE ";
        String query1 = "";

        List<Personnel> list = personnelDAO.findByPersonnelNoInOrPersonnelNo2In(personnelNos, personnelNos);

        Personnel prs = null;

        for (String personnelNo : personnelNos) {
            List<Personnel> list2 = list.stream().filter(p -> (p.getDeleted() == null || p.getDeleted().equals(0)) && (p.getPersonnelNo() != null && p.getPersonnelNo().equals(personnelNo)) || (p.getPersonnelNo2() != null && p.getPersonnelNo2().equals(personnelNo))).collect(Collectors.toList());
            if (list2 == null || list2.size() == 0) {
                result.add(new PersonnelDTO.InfoForStudent());

            } else {
                prs = list2.get(0);
                result.add(modelMapper.map(prs, PersonnelDTO.InfoForStudent.class));
                query1 += "(PERSONNEL_NO='" + prs.getPersonnelNo() + "' and COURSE_ID=" + courseId + " ) OR ";
            }
        }

        if (query1 != "" && courseId > 0) {
            query1 = query1.substring(0, query1.length() - 4);

            List<?> listNA = entityManager.createNativeQuery(query + query1).getResultList();

            if (listNA != null) {
                listNA.stream().forEach(p ->
                        {
                            Object[] item = (Object[]) p;
                            PersonnelDTO.InfoForStudent tmp = (PersonnelDTO.InfoForStudent) result.stream().filter(c -> c.getPersonnelNo() != null && c.getPersonnelNo().equals(item[0].toString())).toArray()[0];
                            tmp.setIsInNA(item[1] == null ? null : Boolean.parseBoolean(item[1].toString()));
                            tmp.setScoreState(item[2] == null ? null : Long.parseLong(item[2].toString()));
                        }
                );
            }
        }

        return result;
    }

    //Unused
    @Override
    @Transactional
    public List<PersonnelDTO.Info> getByPostCode(Long postId) {

        List<Personnel> personnelDTO = null;

        String postCode = postDAO.findOneById(postId);
        if (((personnelDAO.findOneByPostCode(postCode)) == null)) {
            return null;
        } else {
            if ((personnelDAO.findOneByPostCode(postCode)) == null) {
                return null;
            }

            personnelDTO = personnelDAO.findOneByPostCode(postCode);

        }

        return modelMapper.map(personnelDTO, new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());

    }

    //Unused
    @Override
    @Transactional(readOnly = true)
    public List<Personnel> getByPostCode(String postCode) {
        return personnelDAO.findOneByPostCode(postCode);
    }


    //Unused
    @Override
    @Transactional
    public List<PersonnelDTO.Info> getByJobNo(String jobNo) {
        List<Personnel> personnelDTO = null;
        if (((personnelDAO.findOneByJobNo(jobNo)) == null)) {
            return null;
        } else {
            personnelDTO = personnelDAO.findOneByJobNo(jobNo);
        }
        return modelMapper.map(personnelDTO, new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());

    }

    //Unused
    @Override
    @Transactional
    public PersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode) {
        Optional<Personnel> optPersonnel = personnelDAO.findFirstByPersonnelNo(personnelCode);
        final Personnel personnel = optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personnel, PersonnelDTO.PersonalityInfo.class);
    }

    @Override
    public Personnel getByPersonnelNumber(String personnelCode) {
        return personnelDAO.findPersonnelDataByPersonnelNumber(personnelCode);
    }

    //Unused
    @Override
    @Transactional
    public PersonnelDTO.PersonalityInfo getByNationalCode(String nationalCode) {
        Personnel[] optionalPersonnel = personnelDAO.findByNationalCode(nationalCode);
        if (optionalPersonnel != null && optionalPersonnel.length != 0)
            return modelMapper.map(optionalPersonnel[0], PersonnelDTO.PersonalityInfo.class);
        else
            return null;
    }

    //Unused
    @Override
    @Transactional
    public List<PersonnelDTO.Info> findAllStatisticalReportFilter(String reportType) {

        String complexTitle = null, assistant = null, affairs = null, section = null, unit = null;
        List<String> allReportFilter = null;

        switch (reportType) {
            case "complex":
                allReportFilter = personnelDAO.findAllComplexFromPersonnel();
                break;
            case "assistant":
                allReportFilter = personnelDAO.findAllAssistantFromPersonnel();
                break;
            case "affairs":
                allReportFilter = personnelDAO.findAllAffairsFromPersonnel();
                break;
            case "section":
                allReportFilter = personnelDAO.findAllSectionFromPersonnel();
                break;
            case "unit":
                allReportFilter = personnelDAO.findAllUnitFromPersonnel();
                break;
        }

        List<PersonnelDTO.StatisticalReport> listComplex = new ArrayList<>();
        listComplex.add(new PersonnelDTO.StatisticalReport("همه", "همه", "همه", "همه", "همه"));

        for (String filter : allReportFilter) {

            switch (reportType) {
                case "complex":
                    complexTitle = filter;
                    break;
                case "assistant":
                    assistant = filter;
                    break;
                case "affairs":
                    affairs = filter;
                    break;
                case "section":
                    section = filter;
                    break;
                case "unit":
                    unit = filter;
                    break;
            }

            listComplex.add(new PersonnelDTO.StatisticalReport(complexTitle, assistant, affairs, section, unit));
        }

        return modelMapper.map(listComplex, new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional
    public PersonnelDTO.DetailInfo findPersonnel(Long personnelType, Long personnelId, String nationalCode, String personnelNo) {

        PersonnelRegistered personnelRegistered = null;
        SynonymPersonnel synonymPersonnel = null;
        Personnel personnel = null;
        List<Personnel> personnels = null;
        List<PersonnelRegistered> personnelRegistereds = null;

        nationalCode = nationalCode.trim();
        personnelNo = personnelNo.trim();

        if (personnelId > 0 && (personnelType == 1 || personnelType == 2 || personnelType == 3)) {

            if (personnelType == 1) {
                personnel = personnelDAO.findById(personnelId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            } else if (personnelType == 2) {
                personnelRegistered = personnelRegisteredDAO.findById(personnelId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            }else {
                synonymPersonnel = synonymPersonnelDAO.findById(personnelId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            }

        } else if (StringUtils.isNotEmpty(nationalCode)) {

            personnels = personnelDAO.findAllByNationalCodeOrderByIdDesc(nationalCode);

            personnel = personnels.stream().filter(p -> p.getDeleted() == 0).findFirst().orElse(null);

            if (personnel == null) {

                personnelRegistereds = personnelRegisteredDAO.findAllByNationalCodeOrderByIdDesc(nationalCode);
                personnelRegistered = personnelRegistereds.stream().filter(p -> p.getDeleted() == null).findFirst().orElse(null);

                if (personnelRegistered == null) {
                    if (personnels.size() > 0) {
                        personnel = personnels.get(0);
                    } else if (personnelRegistereds.size() > 0) {
                        personnelRegistered = personnelRegistereds.get(0);
                    } else {
                        return null;
                    }
                }
            }

        } else {
            personnels = personnelDAO.findAllByPersonnelNoOrderByIdDesc(personnelNo);

            personnel = personnels.stream().filter(p -> p.getDeleted() == 0).findFirst().orElse(null);

            if (personnel == null) {

                personnelRegistereds = personnelRegisteredDAO.findAllByPersonnelNoOrderByIdDesc(personnelNo);
                personnelRegistered = personnelRegistereds.stream().filter(p -> p.getDeleted() == null).findFirst().orElse(null);

                if (personnelRegistered == null) {
                    if (personnels.size() > 0) {
                        personnel = personnels.get(0);
                    } else if (personnelRegistereds.size() > 0) {
                        personnelRegistered = personnelRegistereds.get(0);
                    } else {
                        throw new TrainingException(TrainingException.ErrorType.NotFound);
                    }
                }
            }
        }

        if (personnel != null) {

            Long trainingTime = tclassDAO.getStudentTrainingTime(personnel.getNationalCode(), personnelNo, DateUtil.getYear());
            personnel.setWorkYears(trainingTime == null ? "عدم آموزش در سال " + DateUtil.getYear() : trainingTime.toString() + " ساعت آموزش در سال " + DateUtil.getYear());

        } else if (personnelRegistereds != null){
            Long trainingTime = tclassDAO.getStudentTrainingTime(personnelRegistered.getNationalCode(), personnelNo, DateUtil.getYear());
            personnelRegistered.setWorkYears(trainingTime == null ? "عدم آموزش در سال " + DateUtil.getYear() : trainingTime.toString() + " ساعت آموزش در سال " + DateUtil.getYear());

        } else if (synonymPersonnel != null){
            Long trainingTime = tclassDAO.getStudentTrainingTime(synonymPersonnel.getNationalCode(), personnelNo, "DateUtil.getYear()");
            synonymPersonnel.setWorkYears(trainingTime == null ? "عدم آموزش در سال " + DateUtil.getYear() : trainingTime.toString() + " ساعت آموزش در سال " + DateUtil.getYear());

        }
        PersonnelDTO.DetailInfo result = null;

        if (personnel != null) {
            result = modelMapper.map(personnel, PersonnelDTO.DetailInfo.class);

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

            if (personnel.getBirthDate() != null) {
                result.setBirthDate(DateUtil.convertMiToKh(formatter.format(personnel.getBirthDate())));
            }

            if (personnel.getEmploymentDate() != null) {
                result.setEmploymentDate(DateUtil.convertMiToKh(formatter.format(personnel.getEmploymentDate())));
            }

            if (personnel.getPostAssignmentDate() != null) {
                result.setPostAssignmentDate(DateUtil.convertMiToKh(formatter.format(personnel.getPostAssignmentDate())));
            }

        } else if (personnelRegistereds != null){
            result = modelMapper.map(personnelRegistered, PersonnelDTO.DetailInfo.class);
        } else if (synonymPersonnel != null) {
            result = modelMapper.map(synonymPersonnel, PersonnelDTO.DetailInfo.class);

        }


        return result;
    }

    @Override
    @Transactional
    public PersonnelDTO.Info getByPersonnelCodeAndNationalCode(String nationalCode, String personnelNo) {

        Personnel personnel = null;
        List<Personnel> personnels = null;

        if (StringUtils.isNotEmpty(nationalCode)) {

            personnels = personnelDAO.findAllByNationalCodeOrderByIdDesc(nationalCode);

            personnel = personnels.stream().filter(p -> p.getDeleted() == 0).findFirst().orElse(null);

            if (personnel == null) {
                if (personnels.size() > 0) {
                    personnel = personnels.get(0);
                }
            }

        } else {
            personnels = personnelDAO.findAllByPersonnelNoOrderByIdDesc(personnelNo);

            personnel = personnels.stream().filter(p -> p.getDeleted() == 0).findFirst().orElse(null);

            if (personnel == null) {
                if (personnels.size() > 0) {
                    personnel = personnels.get(0);
                }
            }
        }

        return modelMapper.map(personnel, PersonnelDTO.Info.class);
    }

    //TODO:must be check
    @Override
    @Transactional
    public SearchDTO.SearchRs<PersonnelDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName) {
        List<String> values = null;
        switch (fieldName) {
            case "companyName":
                values = personnelDAO.findAllCompanyFromPersonnel();
                break;
            case "complexTitle":
                values = personnelDAO.findAllComplexFromPersonnel();
                break;
            case "ccpAssistant":
                values = personnelDAO.findAllAssistantFromPersonnel();
                break;
            case "ccpAffairs":
                values = personnelDAO.findAllAffairsFromPersonnel();
                break;
            case "ccpSection":
                values = personnelDAO.findAllSectionFromPersonnel();
                break;
            case "ccpUnit":
                values = personnelDAO.findAllUnitFromPersonnel();
                break;
            case "ccpArea":
                values = personnelDAO.findAllAreaFromPersonnel();
                break;
            case "postGrade":
                values = personnelDAO.findAllPostGrade();
                break;

        }
        SearchDTO.SearchRs<PersonnelDTO.FieldValue> response = new SearchDTO.SearchRs<>();
        response.setList(new ArrayList<>());
        values.forEach(value -> response.getList().add(new PersonnelDTO.FieldValue(value)));
        response.setTotalCount((long) response.getList().size());
        return response;
    }

    @Override
    public List<Long> inDepartmentIsPlanner(String mojtameCode) {
        return personnelDAO.inDepartmentIsPlanner(mojtameCode);
    }

    @Override
    public Optional<Personnel[]> getOneByNationalCodeAndDeleted(String nationalCode, int deleted) {
        return personnelDAO.findOneByNationalCodeAndDeleted(nationalCode, deleted);
    }

//    @Transactional(readOnly = true)
//    @Override
//    public <R> R getPOrRegisteredP(String personnelNo, Function<Object, R> converter) {
//        Optional<Personnel> optPersonnel = personnelDAO.findFirstByPersonnelNo(personnelNo);
//        return optPersonnel.map(converter).orElse(personnelRegisteredDAO.findOneByPersonnelNo(personnelNo).map(converter).orElse(null));
//    }


    @Override
    public boolean isPresent(String nationalCode) {
        Personnel[] personnels = personnelDAO.findByNationalCode(nationalCode);
        return personnels.length > 0;
    }

    @Override
    public SysUserInfoModel minioValidate() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        SysUserInfoModel model = new SysUserInfoModel();
        if (principal!=null){
            model.setUserId(principal.toString());
            model.setCellNumber("");
            model.setAuthorities(new HashSet<>());
            model.setStatus(200);
        }else {
            Set<String> emptyAuthorities = new HashSet<>();
            model.setUserId("");
            model.setCellNumber("");
            model.setAuthorities(emptyAuthorities);
            model.setStatus(405);
            model.setMessage("user_unknown");
        }
        return model;
    }
}

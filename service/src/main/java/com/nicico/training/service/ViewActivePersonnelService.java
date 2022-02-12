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
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IViewActivePersonnelService;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.PersonnelRegistered;
import com.nicico.training.model.ViewActivePersonnel;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ViewActivePersonnelService implements IViewActivePersonnelService {

    private final ViewActivePersonnelDAO viewActivePersonnelDAO;
    private final PersonnelRegisteredDAO personnelRegisteredDAO;
    private final ModelMapper modelMapper;
    private final PostDAO postDAO;
    private final TclassDAO tclassDAO;

    @Transactional(readOnly = true)
//    @Override
    public List<ViewActivePersonnelDTO.Info> list() {
        return modelMapper.map(viewActivePersonnelDAO.findAll(), new TypeToken<List<ViewActivePersonnelDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
//    @Override
    public ViewActivePersonnelDTO.Info get(Long id) {
        return modelMapper.map(getPersonnel(id), ViewActivePersonnelDTO.Info.class);
    }

    @Transactional(readOnly = true)
//    @Override
    public ViewActivePersonnel getPersonnel(Long id) {
        return viewActivePersonnelDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<ViewActivePersonnelDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(viewActivePersonnelDAO, request, ViewActivePersonnel -> modelMapper.map(ViewActivePersonnel, ViewActivePersonnelDTO.Info.class));
    }

    @Transactional(readOnly = true)
//    @Override
    public TotalResponse<ViewActivePersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(viewActivePersonnelDAO, request, ViewActivePersonnel -> modelMapper.map(ViewActivePersonnel, ViewActivePersonnelDTO.Info.class));
    }

    @Transactional
//    @Override
    public List<ViewActivePersonnelDTO.Info> checkPersonnelNos(List<String> personnelNos) {
        List<ViewActivePersonnelDTO.Info> result = new ArrayList<>();

        List<ViewActivePersonnel> list = viewActivePersonnelDAO.findByPersonnelNoInOrPersonnelNo2In(personnelNos, personnelNos);
        ViewActivePersonnel prs = null;

        for (String personnelNo : personnelNos) {

            if (list.stream().filter(p -> (p.getPersonnelNo() != null && p.getPersonnelNo().equals(personnelNo)) || (p.getPersonnelNo2() != null && p.getPersonnelNo2().equals(personnelNo))).count() == 0) {
                result.add(new ViewActivePersonnelDTO.Info());

            } else {
                prs = list.stream().filter(p -> (p.getPersonnelNo() != null && p.getPersonnelNo().equals(personnelNo)) || (p.getPersonnelNo2() != null && p.getPersonnelNo2().equals(personnelNo))).collect(Collectors.toList()).get(0);
                result.add(modelMapper.map(prs, ViewActivePersonnelDTO.Info.class));
            }
        }

        return result;
    }

//    @Override
    @Transactional
    public List<ViewActivePersonnelDTO.Info> getByPostCode(Long postId) {

        List<ViewActivePersonnel> personnelDTO = null;

        String postCode = postDAO.findOneById(postId);
        if (((viewActivePersonnelDAO.findOneByPostCode(postCode)) == null)) {
            return null;
        } else {
            if ((viewActivePersonnelDAO.findOneByPostCode(postCode)) == null) {
                return null;
            }

            personnelDTO = viewActivePersonnelDAO.findOneByPostCode(postCode);

        }

        return modelMapper.map(personnelDTO, new TypeToken<List<ViewActivePersonnelDTO.Info>>() {
        }.getType());

    }

//    @Override
    @Transactional(readOnly = true)
    public List<ViewActivePersonnel> getByPostCode(String postCode) {
        return viewActivePersonnelDAO.findOneByPostCode(postCode);
    }

//    @Override
    @Transactional
    public List<ViewActivePersonnelDTO.Info> getByJobNo(String jobNo) {
        List<ViewActivePersonnel> personnelDTO = null;
        if (((viewActivePersonnelDAO.findOneByJobNo(jobNo)) == null)) {
            return null;
        } else {
            personnelDTO = viewActivePersonnelDAO.findOneByJobNo(jobNo);
        }
        return modelMapper.map(personnelDTO, new TypeToken<List<ViewActivePersonnelDTO.Info>>() {
        }.getType());

    }

//    @Override
    @Transactional
    public ViewActivePersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode) {
        Optional<ViewActivePersonnel> optPersonnel = viewActivePersonnelDAO.findFirstByPersonnelNo(personnelCode);
        final ViewActivePersonnel personnel = optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personnel, ViewActivePersonnelDTO.PersonalityInfo.class);
    }

//    @Override
    @Transactional
    public ViewActivePersonnelDTO.PersonalityInfo getByNationalCode(String nationalCode) {
        ViewActivePersonnel[] optionalPersonnel = viewActivePersonnelDAO.findByNationalCode(nationalCode);
        if (optionalPersonnel != null && optionalPersonnel.length != 0)
            return modelMapper.map(optionalPersonnel[0], ViewActivePersonnelDTO.PersonalityInfo.class);
        else
            return null;
    }

//    @Override
    @Transactional
    public List<ViewActivePersonnelDTO.Info> findAllStatisticalReportFilter(String reportType) {

        String complexTitle = null, assistant = null, affairs = null, section = null, unit = null;
        List<String> allReportFilter = null;

        switch (reportType) {
            case "complex":
                allReportFilter = viewActivePersonnelDAO.findAllComplexFromPersonnel();
                break;
            case "assistant":
                allReportFilter = viewActivePersonnelDAO.findAllAssistantFromPersonnel();
                break;
            case "affairs":
                allReportFilter = viewActivePersonnelDAO.findAllAffairsFromPersonnel();
                break;
            case "section":
                allReportFilter = viewActivePersonnelDAO.findAllSectionFromPersonnel();
                break;
            case "unit":
                allReportFilter = viewActivePersonnelDAO.findAllUnitFromPersonnel();
                break;
        }

        List<ViewActivePersonnelDTO.StatisticalReport> listComplex = new ArrayList<>();
        listComplex.add(new ViewActivePersonnelDTO.StatisticalReport("همه", "همه", "همه", "همه", "همه"));

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

            listComplex.add(new ViewActivePersonnelDTO.StatisticalReport(complexTitle, assistant, affairs, section, unit));
        }

        return modelMapper.map(listComplex, new TypeToken<List<ViewActivePersonnelDTO.Info>>() {
        }.getType());
    }

//    @Override
    @Transactional
    public ViewActivePersonnel findPersonnelByPersonnelId(Long personnelId, String personnelNo) {

        Long personnel_Id = personnelId != 0 ? personnelId : viewActivePersonnelDAO.getPersonnelIdByPersonnelNo(personnelNo);
        PersonnelRegistered personnelRegistered = new PersonnelRegistered();
        ViewActivePersonnel personnel = viewActivePersonnelDAO.findPersonnelById(personnel_Id);

        if (personnel != null) {

            Long trainingTime = tclassDAO.getStudentTrainingTime(personnel.getNationalCode(), personnelNo, DateUtil.getYear());
            personnel.setWorkYears(trainingTime == null ? "عدم آموزش در سال " + DateUtil.getYear() : trainingTime.toString() + " ساعت آموزش در سال " + DateUtil.getYear());

        } else {

            personnelRegistered = personnelRegisteredDAO.findPersonnelRegisteredByPersonnelNo(personnelNo);
            Long trainingTime = tclassDAO.getStudentTrainingTime(personnelRegistered.getNationalCode(), personnelNo, DateUtil.getYear());
            personnelRegistered.setWorkYears(trainingTime == null ? "عدم آموزش در سال " + DateUtil.getYear() : trainingTime.toString() + " ساعت آموزش در سال " + DateUtil.getYear());

        }

        return personnel != null ? personnel : modelMapper.map(personnelRegistered, ViewActivePersonnel.class);
    }

//    @Override
    @Transactional
    public SearchDTO.SearchRs<ViewActivePersonnelDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName) {
        List<String> values = null;
        switch (fieldName) {
            case "companyName":
                values = viewActivePersonnelDAO.findAllCompanyFromPersonnel();
                break;
            case "complexTitle":
                values = viewActivePersonnelDAO.findAllComplexFromPersonnel();
                break;
            case "ccpAssistant":
                values = viewActivePersonnelDAO.findAllAssistantFromPersonnel();
                break;
            case "ccpAffairs":
                values = viewActivePersonnelDAO.findAllAffairsFromPersonnel();
                break;
            case "ccpSection":
                values = viewActivePersonnelDAO.findAllSectionFromPersonnel();
                break;
            case "ccpUnit":
                values = viewActivePersonnelDAO.findAllUnitFromPersonnel();
                break;
            case "ccpArea":
                values = viewActivePersonnelDAO.findAllAreaFromPersonnel();
                break;
            case "postGrade":
                values = viewActivePersonnelDAO.findAllPostGrade();
                break;

        }
        SearchDTO.SearchRs<ViewActivePersonnelDTO.FieldValue> response = new SearchDTO.SearchRs<>();
        response.setList(new ArrayList<>());
        values.forEach(value -> response.getList().add(new ViewActivePersonnelDTO.FieldValue(value)));
        response.setTotalCount((long) response.getList().size());
        return response;
    }

    @Override
    public Optional<ViewActivePersonnel> findById(Long personnelId) {
        return viewActivePersonnelDAO.findById(personnelId);
    }

    @Override
    public String getPersonnelFullName(Long personnelId) {
        return viewActivePersonnelDAO.getPersonnelFullName(personnelId);
    }

    @Override
    public ViewActivePersonnel[] findByNationalCode(String personnelNationalCode) {
        return viewActivePersonnelDAO.findByNationalCode(personnelNationalCode);
    }

    @Override
    public ViewActivePersonnel findFirstByPostId(Long postId) {
        return viewActivePersonnelDAO.findFirstByPostId(postId);
    }

//    @Transactional(readOnly = true)
//    @Override
//    public <R> R getPOrRegisteredP(String personnelNo, Function<Object, R> converter) {
//        Optional<ViewActivePersonnel> optPersonnel = viewActivePersonnelDAO.findFirstByPersonnelNo(personnelNo);
//        return optPersonnel.map(converter).orElse(personnelRegisteredDAO.findOneByPersonnelNo(personnelNo).map(converter).orElse(null));
//    }

}

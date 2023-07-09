package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.FeeItemDTO;
import com.nicico.training.iservice.IFeeItemService;
import com.nicico.training.mapper.FeeItem.FeeItemMapper;
import com.nicico.training.model.FeeItem;
import com.nicico.training.repository.FeeItemDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FeeItemService implements IFeeItemService {

    private final FeeItemDAO feeItemDAO;
    private final TclassDAO tclassDAO;
    private final FeeItemMapper mapper;

    @Override
    public FeeItem get(Long id) {
        return feeItemDAO.findById(id)
                .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public FeeItemDTO.Info create(FeeItemDTO.Create request) {
        FeeItem feeItem = mapper.toEntity(request);
        FeeItem savedFeeItem = feeItemDAO.save(feeItem);
        return mapper.toInfo(savedFeeItem);
    }

    @Override
    public FeeItem update(FeeItemDTO.Create update) {
        FeeItem feeItem = get(update.getId());
        FeeItem updated = mapper.update(update, feeItem);
        return feeItemDAO.save(updated);
    }

    @Override
    public SearchDTO.SearchRs<FeeItemDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException {
        return SearchUtil.search(feeItemDAO, request, mapper::toInfo);
    }

    @Override
    public void delete(Long id) {
        try {
            feeItemDAO.deleteById(id);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    public List<FeeItemDTO.Info> getAllByClassId(Long classId) {
        List<FeeItem> feeItemsByClassId = feeItemDAO.findAllByClassId(classId);
        List<FeeItemDTO.Info> infos = mapper.toInfos(feeItemsByClassId);
        infos.forEach(info -> tclassDAO.findById(classId).ifPresent(tclass -> info.setClassTitle(tclass.getTitleClass())));
        return infos;
    }
}

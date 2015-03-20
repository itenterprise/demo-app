package com.it.demo.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.it.core.tools.DateTimeFormatter;
import com.it.core.tools.TextViewTools;
import com.it.core.tools.ViewTools;
import com.it.demo.R;
import com.it.demo.model.Connection;

import java.util.List;

/**
 * Адаптер заполнения списка подключений
 */
public class ConnectionAdapter extends ArrayAdapter<Connection> {
	private LayoutInflater mInflater;
	private List<Connection> mItems;
	private boolean mIsSimpleView;

	/**
	 * Конструктор
	 * @param context Контекст
	 * @param connections Список подключений
	 * @param simpleView Признак упрощенного вида
	 */
	public ConnectionAdapter(Context context, List<Connection> connections, boolean simpleView) {
		super(context, R.layout.connection_item, connections);
		mInflater = (LayoutInflater) context.getSystemService( Context.LAYOUT_INFLATER_SERVICE );
		mItems = connections;
		mIsSimpleView = simpleView;
	}

	/**
	 * Конструктор
	 * @param context Контекст
	 * @param connections Список подключений
	 */
	public ConnectionAdapter(Context context, List<Connection> connections) {
		this(context, connections, false);
	}

	/**
	 * Получить количество подключений
	 * @return Количество подключений
	 */
    public int getCount() {
        return mItems.size();
    }

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			convertView = mInflater.inflate(R.layout.connection_item, parent, false);
			viewHolder = new ViewHolder();
			viewHolder.fio = (TextView) convertView.findViewById(R.id.connection_item_fio);
			viewHolder.function = (TextView) convertView.findViewById(R.id.connection_item_function);
			viewHolder.status = (TextView) convertView.findViewById(R.id.connection_item_status);
			viewHolder.statusCircle = (ImageView) convertView.findViewById(R.id.connection_item_status_color);
			viewHolder.date = (TextView) convertView.findViewById(R.id.connection_item_date);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		// Получение подключения по позиции в списке
		Connection item = mItems.get(position);
		int fioVisibility = View.GONE;
		// Если упрощенний вид, тогда не отображать ФІО пользователя
		if (!mIsSimpleView) {
			fioVisibility = View.VISIBLE;
			TextViewTools.setText(viewHolder.fio, item.getFio());
		}
		// Заполнение визуальных элементов данными
		viewHolder.fio.setVisibility(fioVisibility);
		TextViewTools.setText(viewHolder.function, item.getFunction());
		TextViewTools.setText(viewHolder.status, item.getStatus());
		ViewTools.setCircleImageView(viewHolder.statusCircle, Color.parseColor(item.getStatusColor()));
		TextViewTools.setText(viewHolder.date, DateTimeFormatter.getStringDate(getContext(), item.getDateTransfer()));
		return convertView;
	}

	// Класс для сохранения во внешний класс и для ограничения доступа
	// из потомков класса
	private static class ViewHolder {
		TextView fio;
		TextView function;
		TextView status;
		ImageView statusCircle;
		TextView date;
	}
}